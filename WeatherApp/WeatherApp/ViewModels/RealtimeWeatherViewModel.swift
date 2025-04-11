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
    
    @Published var location: CLLocation = CLLocation.defaultLocation // 위치가 30킬로미터 이상 차이나면 업데이트
    @Published var weather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private var weatherService = WeatherAPIService()
    
    private var locationManager = CLLocationManager()
    
    
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
    
    func getWeather() async {
        DispatchQueue.main.async {
            self.isLoading = true
            do {self.isLoading = false}
        }
        
        do {
            try await self.weather = weatherService.fetchWeather(for: location) // update Occur here
        }
        catch {
            print("Error: \(error)")
        }
        
    }
    
}
extension RealtimeWeatherViewModel  {
    
    //    private var TimerPublisher: AnyPublisher<WeatherData?, Error> { // 1분마다 날씨정보 가져옴
    //        Timer.publish(every: 60.0, on: .main, in: .common)
    //            .autoconnect()
    //            .print("Timer Tick")
    //            .flatMap { [weak self] _ -> AnyPublisher<WeatherData?, Error> in
    //                guard let self = self else {
    //                    return Empty<WeatherData?, Error>.init().eraseToAnyPublisher()
    //                }
    //                return Future<WeatherData?, Error> { promise in
    //                    promise(.success(self.getWeather()))
    //                }
    //            }
    //            .eraseToAnyPublisher()
    //    }
    private func createWeatherFetchPublisher(for location: CLLocation) -> AnyPublisher<WeatherData, Error> {
        // Future를 사용하여 async/await 함수를 Combine 퍼블리셔로 래핑
        Future<WeatherData, Error> { promise in
            Task { // 비동기 작업 시작
                do {
                    print("Fetching weather for location: \(location.coordinate)...")
                    // 실제 WeatherKit 호출 및 WeatherData로 매핑하는 비동기 함수 호출
                    let fetchedData = try await self.weatherService.fetchWeather(for: location)
                    promise(.success(fetchedData)) // 성공 시 결과 전달
                } catch {
                    promise(.failure(error)) // 실패 시 에러 전달
                }
            }
        }
        .eraseToAnyPublisher() // 타입을 AnyPublisher로 통일
    }
}

extension RealtimeWeatherViewModel: CLLocationManagerDelegate  {
    
    // 위치 정보 업데이트 시 호출됨 (필수 구현)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // locations 배열에는 최신 위치 정보가 들어 있습니다.
        if let newLocation = locations.first {
            print("✅ Received location: \(newLocation)")
            // 여기서 self.location = newLocation 같은 로직을 수행할 수 있습니다.
            // 예를 들어, 특정 거리 이상 차이날 때만 업데이트 하려면:
            if location.distance(from: newLocation) > 30000 { // 30km 이상 차이나면 업데이트 (예시)
                self.location = newLocation
                // 위치가 업데이트 되었으므로 날씨 정보도 다시 가져올 수 있습니다.
                Task {
                    await getWeather()
                }
            } else {
                print("Location difference is not significant enough to update.")
                // 처음 위치를 받는 경우이거나, getWeather를 아직 호출 안했다면 여기서 호출할 수도 있습니다.
                if self.weather == nil { // 아직 날씨 정보가 없다면 가져오기
                    Task {
                        await getWeather()
                    }
                }
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
