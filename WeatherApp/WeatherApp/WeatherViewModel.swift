//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import CoreLocation
import SwiftUI

// TODO: ViewModel 작업

class WeatherViewModel: ObservableObject {
    
    // 서비스
    private var weatherService = WeatherService.shared
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
            let weatherData = try await weatherService.fetchWeather(for: location)
            
            self.weather = weatherData
            self.location = location
            self.isLoading = false
        } catch {
            self.error = error
            self.isLoading = false
            print("🔴 날씨 정보 가져오기 실패: \(error.localizedDescription)")
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
    }
}

extension WeatherViewModel: LocationServiceDelegate {
    func locationDidUpdate(location: CLLocation) {
        self.location = location
        
        Task {
            await fetchWeather(for: location)
        }
    }
    
    func locationAuthorizationDidChange(status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationService.startUpdatingLocation()
        }
    }
    
    func locationDidFailWithError(error: Error) {
        self.error = error
        print("🔴 위치 정보 가져오기 실패: \(error.localizedDescription)")
    }
}
