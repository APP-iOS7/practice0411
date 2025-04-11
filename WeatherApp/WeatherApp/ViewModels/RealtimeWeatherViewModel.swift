//
//  RealtimeViewModel.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import Foundation
import CoreLocation
import Combine

class RealtimeWeatherViewModel: ObservableObject {
    @Published var location: CLLocation = CLLocation.defaultLocation // 위치가 30킬로미터 이상 차이나면 업데이트
    @Published var weather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var error: Error?

    
    private var weatherService = WeatherAPIService()
    private let locationManager = CLLocationManager()
    
    
    func getLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    func getLocation() {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if CLLocationManager.locationServicesEnabled() { // 권한이 있는 경우에만
                locationManager.requestLocation()
            }
        default:
            print("No Permission")
            break
        }
    }
    
    func getWeather() async -> WeatherData {
        isLoading = true
        defer {isLoading = false}
        
        do {
            try await self.weather = weatherService.fetchWeather(for: location)
        }
        catch {
            print("Error: \(error)")
        }
        
    }
    
}
extension RealtimeWeatherViewModel  {
    
    private var TimerPublisher: AnyPublisher<WeatherData?, Error> { // 1분마다 날씨정보 가져옴
        Timer.publish(every: 60.0, on: .main, in: .common)
            .autoconnect()
            .print("Timer Tick")
            .flatMap { [weak self] _ -> AnyPublisher<WeatherData?, Error> in
                guard let self = self else {
                    return Empty<WeatherData?, Error>.init().eraseToAnyPublisher()
                }
                return Future<WeatherData?, Error> { promise in
                    promise(.success(self.getWeather()))
                }
            }
            .eraseToAnyPublisher()
    }
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
