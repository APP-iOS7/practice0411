//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//

import Foundation
import CoreLocation
import Combine

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var location: String = ""
    @Published var weather: WeatherData?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let geocoder = CLGeocoder()
    private let weatherService = WeatherService()
    
    func fetchWeather(currentLocation: CLLocation) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // 위치 정보로 날씨를 요청
            let data = try await weatherService.fetchWeather(location: currentLocation)
            self.weather = data
        } catch {
            errorMessage = "날씨 정보를 불러오지 못했어요."
        }
    }
    
    func fetchWeatherByLocation() async {
        guard !location.isEmpty else {
            errorMessage = "위치 정보를 입력해주세요."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(location)
            guard let location = placemarks.first?.location else {
                errorMessage = "위치를 찾을 수 없어요."
                return
            }
            
            let data = try await weatherService.fetchWeather(location: location)
            self.weather = data
        } catch {
            errorMessage = "날씨 정보를 불러오지 못했어요."
        }
    }
}

