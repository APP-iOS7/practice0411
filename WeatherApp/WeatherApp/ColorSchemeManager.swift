//
//  ColorSchemeManager.swift
//  WeatherApp
//
//  Created by 김동영 on 4/11/25.
//

import SwiftUI

class ColorSchemeManager: ObservableObject {
    @Published var colorScheme: ColorScheme? = .light
    
    func toggle() {
        withAnimation(.easeInOut(duration: 0.5)) {
            colorScheme = (colorScheme == .light) ? .dark : .light
        }
    }
}
