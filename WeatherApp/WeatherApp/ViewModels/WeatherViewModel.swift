//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by NO SEONGGYEONG on 4/11/25.
//

import Foundation
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData = .empty
    @Published var isLoading: Bool = false
    @Published var error: Error?
    @Published var location: CLLocation?
    
    private var myWeatherService = MyWeatherService()
    
    func checkWeather() async {
        guard let location = myWeatherService.currentLocation else {
            print("위치 정보를 가져올 수 없습니다.")
            return
        }
        
        do {
            if !isLoading {
                await myWeatherService.locationManager.startUpdatingLocation()
                
                let data = try await myWeatherService.fetchWeather(for: location)
                myWeatherService.locationManager.startUpdatingLocation()
                DispatchQueue.main.async { [weak self] in
                    self?.weather = data
                    //                    self?.isLoading = false
                }
                print("날씨 정보: \(data)")
            }
        } catch {
            print("날씨 정보를 가져오는 중 오류 발생: \(error)")
            
        }
    }
    
    
    
    
}


