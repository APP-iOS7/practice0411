//
//  RealtimeViewModel.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import Foundation
import CoreLocation
import Combine


class RealtimeWeatherViewModel: NSObject, ObservableObject, @unchecked Sendable {
    // 위치가 10킬로미터 이상 차이나면 업데이트
    @Published var location: CLLocation = CLLocation.defaultLocation
    @Published var weather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var error: Error?

    private var weatherService = WeatherAPIService()
    private var locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    override init() {
        super.init()

        locationManager.delegate = self

        setLocationPublisher()
        setTimerWeatherPublisher()
    }

    func setLocationPublisher() {
        $location
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .flatMap { [weak self] location -> AnyPublisher<WeatherData?, Never> in
                guard let self = self else {
                    return Empty<WeatherData?, Never>().eraseToAnyPublisher()
                }
                return Future<WeatherData?, Error> {promise in
                    Task {
                        do {
                            print("Combine: Fetching weather for location: \(location.coordinate)...")
                            let fetchedData = await self.getWeather()
                            promise(.success(fetchedData))
                        }
                    }
                }.catch({ _ in //promise(.failure(error)) 감지
                    return Empty()
                })
                .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$weather)
    }

    func setTimerWeatherPublisher() {
        Timer.publish(every: 5, on: .main, in: .common)
            .autoconnect()
            .print("Timer Tick")
            .flatMap {[weak self] _ -> AnyPublisher<WeatherData?, Error> in
                // Future는 동기 클로저를 받음
                self?.isLoading = true
                return Future<WeatherData?, Error> { promise in
                    // Task를 생성하여 비동기 컨텍스트 제공
                    Task {
                        // Task 내부에서 async 함수 호출
                        let weatherData = await self?.getWeather()
                        // 성공 시 promise 호출
                        promise(.success(weatherData))
                    }
                }
                .eraseToAnyPublisher()
            }
            .catch { [weak self] error -> AnyPublisher<WeatherData?, Never> in
                print("Timer Publisher Error: \(error)")
                self?.error = error
                return Just(nil).eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] weather in
                print("isMainThread2 : \(Thread.isMainThread)")
                self?.isLoading = false
                self?.weather = weather
            }
            .store(in: &cancellables)
    }


    func getLocationPermission() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }

    func getLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            // 권한이 있는 경우에만
            locationManager.requestLocation()
        default:
            print("No Permission")
            break
        }
    }

    func getWeather() async -> WeatherData?{
        do {
            let newWeather = try await weatherService.fetchWeather(for: location)
            return newWeather
        } catch {
            print("Error: \(error)")
            self.error = error // 메인 스레드에서 안전
            return nil
        }
    }

}

extension RealtimeWeatherViewModel: CLLocationManagerDelegate  {

    // 위치 정보 업데이트 시 호출됨 (필수 구현)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations 배열에는 최신 위치 정보가 들어 있습니다.
        if let newLocation = locations.first {
            print("✅ Received location: \(newLocation)")

            if self.location == CLLocation.defaultLocation {
                // 초기 상태이므로 바로 업데이트
                self.location = newLocation

            } else if self.location.distance(from: newLocation) >= 10000 { // 10km 이상일 때만 업데이트
                self.location = newLocation
            }
        }
    }

    // 위치 정보 가져오기 실패 시 호출됨 (필수 구현)
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
        // 사용자에게 오류를 알리거나 기본 위치를 사용하는 등의 처리를 할 수 있습니다.
        // self.error = error // ViewModel에 에러 상태 저장
    }

    // (선택 사항, 이전 질문에서 논의된 내용) 권한 상태 변경 시 호출됨
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("👮‍♀️ Authorization status changed: \(manager.authorizationStatus.rawValue)")
        // 권한 상태가 변경되었을 때 필요한 로직 수행
    }
}
