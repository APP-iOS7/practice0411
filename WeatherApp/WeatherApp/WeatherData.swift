//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 박세라 on 4/11/25.
//

import Foundation

struct WeatherData: Codable {
    var temperature: Double
    var description: String
    var humidity: Double
    var windSpeed: Double
    var symbolName: String
}
