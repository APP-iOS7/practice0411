//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    
    @StateObject private var colorSchemeManager = ColorSchemeManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(colorSchemeManager)
                .preferredColorScheme(colorSchemeManager.colorScheme)
        }
    }
}
