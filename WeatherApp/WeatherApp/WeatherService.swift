//
//  WeatherService.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//


import Foundation
import WeatherKit
import CoreLocation

public class WeatherService {

    private let service = WeatherKit.WeatherService()
    
    func fetchWeather(location: CLLocation) async throws -> WeatherData {
        let weather = try await service.weather(for: location)
        let currentWeather = weather.currentWeather
        
        return WeatherData(
            temperature: currentWeather.temperature.value,
            description: currentWeather.condition.description,
            humidity: currentWeather.humidity,
            windSpeed: currentWeather.wind.speed.value,
            symbolName: currentWeather.symbolName
        )
    }
}
