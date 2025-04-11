//
//  Constants.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import Foundation

enum Constants {
    enum WeatherIcons {
        static func iconFame(for description: String) -> String {
            let lowercased = description.lowercased()
            
            if lowercased.contains("맑음") || lowercased.contains("clear") {
                return "sun.max.fill"
            } else if lowercased.contains("구름") || lowercased.contains("cloud") {
                return "cloud.fill"
            } else if lowercased.contains("비") || lowercased.contains("rain") {
                return "cloud.rain.fill"
            } else if lowercased.contains("눈") || lowercased.contains("snow") {
                return "cloud.snow.fill"
            } else if lowercased.contains("안개") || lowercased.contains("fog") {
                return "cloud.fog.fill"
            } else if lowercased.contains("번개") || lowercased.contains("thunder") {
                return "cloud.bolt.fill"
            } else {
                return "thermometer"
            }
        }
    }
}
