//
//  WeatherService.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

// MARK: - 날씨 서비스 클래스
class WeatherService {
    
    static let shared = WeatherService()
    private let weatherService = WeatherKit.WeatherService()
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        
        let weather = try await weatherService.weather(for: location)
            
        let currentWeather = weather.currentWeather
        
        // WeatherData 데이터로 반환
        return WeatherData(temperature: currentWeather.temperature.value,
                           description: currentWeather.condition.description,
                           humidity: currentWeather.humidity,
                           windSpeed: currentWeather.wind.speed)
    }
}
