//
//  Item.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import Foundation
import SwiftData

@Model
final class SDWeatherData {
    var temperature: Double
    var humidity: Double
    var windSpeed: Double
    var weatherDescription: String
    
    
    init(temperature: Double, humidity: Double, windSpeed: Double, weatherDescription: String) {
        self.temperature = temperature
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.weatherDescription = weatherDescription
    }
}
