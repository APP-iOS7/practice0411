//
//  WeatherData.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import Foundation

struct WeatherData: Codable {
    let temperature: Double
    let description: String
    let humidity: Double
    let windSpeed: Double
    let symbolName: String
    
    static let empty = WeatherData(temperature: 0.0, description: "", humidity: 0.0, windSpeed: 0.0, symbolName: "")
}
