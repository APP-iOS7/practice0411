//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import CoreLocation
import SwiftUI
import WeatherKit

enum WeatherServiceError: Error {
    case failedToFetchWeather
    case locationError
    case networkError

    var message: String {
        switch self {
        case .failedToFetchWeather:
            return "날씨 정보를 가져오는데 실패했습니다."
        case .locationError:
            return "위치 정보를 가져오는데 실패했습니다."
        case .networkError:
            return "네트워크 연결이 끊겼습니다."
        }
    }
}

class WeatherViewModel: ObservableObject {
    
    // 서비스
    private let weatherService = WeatherKit.WeatherService()
    private var locationService = LocationService.shared
    
    @Published var weather: WeatherData?
    @Published var error: Error?
    @Published var isLoading = false
    @Published var location: CLLocation?
    
    
    init() {
        setupLocationService()
    }
    
    private func setupLocationService() {
        locationService.delegate = self
        locationService.requestLocationAuthorization()
    }
    
    // 날씨 정보 가져오기
    @MainActor
    func fetchWeather(for location: CLLocation? = nil) async {
        isLoading = true
        error = nil
        
        // 기본값 : 서울 (위치 값 못받아 왔을 경우)
        do {
            let location = location ?? self.location ?? CLLocation(latitude: 37.5665, longitude: 126.9780)
            //CLLocation(latitude: 35.1796, longitude: 129.0756)//
            print("🟩 현재 위치 좌표:\(location)")
            
            try await Task.sleep(nanoseconds: 500_000_000)
            
            let weather = try await weatherService.weather(for: location)

            let currentWeather = weather.currentWeather

            let transDescription = Constants.WeatherTranslation.translate(for: currentWeather.condition.description)

            // WeatherData 데이터로 반환
            let weatherData = WeatherData(temperature: currentWeather.temperature.value,
                                          description: transDescription, // currentWeather.condition.description,
                                          humidity: currentWeather.humidity,
                                          windSpeed: currentWeather.wind.speed.value)

            self.weather = weatherData
            self.location = location
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
            print("🔴 날씨 정보 가져오기 실패(ViewModel): \(error.localizedDescription)")
        }
    }

    // 새로고침
    func refreshWeather() {
        Task {
            await fetchWeather(for: location)
        }
    }
    
    func requestLocationPermission() {
        locationService.requestLocationAuthorization()
        locationService.startUpdatingLocation()
    }
}

extension WeatherViewModel: LocationServiceDelegate {
    func locationDidUpdate(location: CLLocation) {
        self.location = location
        
        Task {
            try? await fetchWeather(for: location)
        }
    }
    
    func locationAuthorizationDidChange(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationService.startUpdatingLocation()
        }
    }
    
    func locationDidFailWithError(error: Error) {
        self.error = error
        print("🔴 위치 정보 가져오기 실패(ViewModel): \(error.localizedDescription)")
    }
}
