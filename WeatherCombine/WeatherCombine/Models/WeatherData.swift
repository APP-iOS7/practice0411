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
    
    init(temperature: Double, description: String, humidity: Double, windSpeed: Double) {
        self.temperature = temperature
        self.description = description
        self.humidity = humidity
        self.windSpeed = windSpeed
    }
    
    init(weather: CurrentWeather) {
        self.temperature = weather.temperature.value
        self.description = weather.condition.description
        self.humidity = weather.humidity
        self.windSpeed = weather.wind.speed.value
    }
}

extension WeatherData {
    static let empty: WeatherData = WeatherData(temperature: 0, description: "", humidity: 0, windSpeed: 0)
}
