//
//  ContentView.swift
//  WeatherCombine
//
//  Created by 멘태 on 4/11/25.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    private let locationManager = LocationDataManager.shared.locationManager
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    ContentView()
}
