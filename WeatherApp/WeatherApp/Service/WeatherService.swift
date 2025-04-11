//
//  WeatherService.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

enum APIError: Error {
    case permissionDenied
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return WeatherError.permissionDenied.errorDescription
        }
    }
}

class WeatherService {
    static func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            let weatherService = WeatherKit.WeatherService()
            let weather = try await weatherService.weather(for: location).currentWeather
            return WeatherData(temperature: weather.temperature.value, description: weather.condition.description, humidity: weather.humidity, windSpeed: weather.wind.speed.value)
        } catch {
            throw APIError.permissionDenied
        }
    }
}
