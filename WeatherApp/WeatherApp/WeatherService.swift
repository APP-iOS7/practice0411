//
//  WeatherService.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

class WeatherAPIService {
    // 이새끼 역할을 어떻게 해야할까?
    
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            let fetchedResult = try await WeatherService.shared.weather(for: location)
            let currentWether = fetchedResult.currentWeather
            print(currentWether)
            
            return WeatherData.init(from: fetchedResult) // type: Weather
        }
        catch {
            print("날씨 정보를 가져오지 못했습니다. \(error)")
            throw APIError.requestFailed(error: error)
        }
        
    }
        
}

