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
    
    func fetchWeather() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let placemarks = try await geocoder.geocodeAddressString(location)
            guard let location = placemarks.first?.location else {
                errorMessage = "위치를 찾을 수 없어요."
                return
            }
            
            print(location.coordinate.longitude, location.coordinate.latitude)
            
            let data = try await weatherService.fetchWeather(location: location)
            self.weather = data
        } catch {
            errorMessage = "날씨 정보를 불러오지 못했어요."
        }
    }
}

