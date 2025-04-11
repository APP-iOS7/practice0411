//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import Foundation
import WeatherKit


struct WeatherData: Codable, Identifiable, Equatable {
    static let sample: WeatherData = .init(
        temperature: 25,
        humidity: 60,
        windSpeed: 4.0,
        weatherDescription: "Sunny"
    )
    
    var id: UUID = UUID()
    var temperature: Double
    var humidity: Double
    var windSpeed: Double
    var weatherDescription: String
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        lhs.id == rhs.id
    }
    
    init(temperature: Double, humidity: Double, windSpeed: Double, weatherDescription: String) {
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.weatherDescription = weatherDescription
    }
    
    init(from: Weather) {
        self.temperature = from.currentWeather.temperature.value
        self.humidity = from.currentWeather.humidity
        self.windSpeed = from.currentWeather.wind.speed.value
        self.weatherDescription = from.currentWeather.condition.description
    }
}
