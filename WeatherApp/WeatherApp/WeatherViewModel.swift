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
    @Published var weather: WeatherData?
    @Published var error: Error?
    @Published var isLoading = false
    @Published var location: CLLocation?
    
    // 서비스
    private var locationService = LocationService.shared
    private var weatherService = WeatherService.shared
    
    init() {
        setupLocationService()
    }
    
    private func setupLocationService() {
        
    }
}

