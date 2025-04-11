//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import CoreLocation
import SwiftUI

// TODO: ViewModel 작업

class WeatherViewModel: ObservableObject {
    // 서비스
    private var weatherService = WeatherService.shared
    private var locationService = LocationService.shared
    
    @Published var weather: WeatherData?
    @Published var error: Error?
    @Published var isLoading = false
    @Published var location: CLLocation?
    
    
    init() {
        setupLocationService()
    }
    
    private func setupLocationService() {
        
    }
}

