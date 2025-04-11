//
//  WeatherData.swift
//  WeatherCombine
//
//  Created by 멘태 on 4/11/25.
//
import WeatherKit

struct WeatherData: Codable {
    let temperature: Double
    let description: String
    let humidity: Double
    let windSpeed: Double

    
    init(weather: CurrentWeather) {
        self.temperature = weather.temperature.value
        self.description = weather.symbolName.description
        self.humidity = weather.humidity
        self.windSpeed = weather.wind.speed.value
    }
}
