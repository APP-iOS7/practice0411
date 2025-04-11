//
//  WeatherService.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherService {
    static func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            let weatherService = WeatherKit.WeatherService()
            let weather = try await weatherService.weather(for: location).currentWeather
            return WeatherData(temperature: weather.temperature.value, description: weather.condition.description, humidity: weather.humidity, windSpeed: weather.wind.speed.value, symbolName: weather.symbolName)
        } catch {
            throw WeatherError.permissionDenied
        }
    }
}
