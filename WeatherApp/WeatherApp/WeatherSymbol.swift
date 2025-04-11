//
//  WeatherSymbol.swift
//  WeatherApp
//
//  Created by NO SEONGGYEONG on 4/11/25.
//

import Foundation
import WeatherKit

class WeatherSymbol {
    func toSFSymbol(weatherDescription: String) -> String {
        switch weatherDescription {
        case "Clear":
            return "sun.max"
        case "Partly cloudy":
            return "cloud.sun"
        case "Cloudy":
            return "cloud"
        case "Rain":
            return "cloud.rain"
        case "Thunderstorm":
            return "cloud.bolt.rain"
        case "Snow":
            return "cloud.snow"
        case "Fog":
            return "cloud.fog"
        case "Wind":
            return "wind"
        default:
            return "questionmark"
        }
    }
}
