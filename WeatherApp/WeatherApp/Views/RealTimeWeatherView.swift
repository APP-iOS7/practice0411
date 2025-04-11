//
//  RealTimeWeatherView.swift
//  WeatherApp
//
//  Created by 이재용 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct RealtimeWeatherView: View {
    @StateObject private var viewModel = RealtimeWeatherViewModel()
    @State private var longitude: String = ""
    @State private var latitude: String = ""
    
    func updateViewModelLocation() {
        
        guard let longitudeDouble: Double = Double(longitude),
              let latitudeDouble: Double = Double(latitude)
        else {
            return
        }
        
        let newLocation: CLLocation = CLLocation.init(latitude: latitudeDouble, longitude: longitudeDouble)
        viewModel.location = newLocation
    }
    
    func checkDoubleOnSummit(text: String) -> Bool {
        return Double(text) != nil
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("현 위치")
                    Text("경도 : \(viewModel.location.coordinate.latitude)")
                    Text("위도 : \(viewModel.location.coordinate.longitude)")
                }
                Spacer()
                Button("위치정보 가져오기") {
                    viewModel.getLocationPermission()
                    viewModel.getLocation()
                }.buttonStyle(.borderedProminent)
            }
           
            ScrollView {
                HStack {
                    Text("경도 입력")
                    TextField("127.23", text: $latitude)
                    Text("위도 입력")
                    TextField("35.5", text: $longitude)
                }
                
                HStack {
                    Text(viewModel.weather?.weatherDescription ?? "날씨 몰랑")
                    Text(viewModel.weather?.temperature.description ?? 0.0.description)
                    Text(viewModel.weather?.humidity.description ?? 0.0.description)
                    Text(viewModel.weather?.windSpeed.description ?? 0.0.description)
                }
            }.navigationTitle("Real Time Weather")
        }
        .padding()
        
    }
}

#Preview {
    RealtimeWeatherView()
}
