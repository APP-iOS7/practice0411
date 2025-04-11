//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import Foundation
import CoreLocation

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var location: CLLocation = CLLocation.init()
    
    func fetchWeather() async {
        do {
            isLoading = true
            let locationService = LocationService()
            locationService.requestLocation()
            location = locationService.setCurrentCLLocation()
            weather = try await WeatherService.fetchWeather(for: self.location)
            isLoading = false
        } catch {
            debugPrint("날씨 정보 가져오기 실패: \(error)")
        }
    }
    
    func fetchCustomLocationWeather(_ latitude: String, _ longitude: String) async {
        do {
            isLoading = true
            let customLocation = CLLocationCoordinate2D(latitude: Double(latitude) ?? 0.0, longitude: Double(longitude) ?? 0.0)
            location = CLLocation(latitude: customLocation.latitude, longitude: customLocation.longitude)
            weather = try await WeatherService.fetchWeather(for: self.location)
            isLoading = false
        } catch {
            debugPrint("날씨 정보 가져오기 실패: \(error)")
        }
    }
    
    func resetWeather() {
        weather = WeatherData.empty
    }
    
}
