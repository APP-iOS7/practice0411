//
//  Weather.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import Foundation
import SwiftData


@Model
class Weather {
    var weather: String
    var icon: String
    var location: String
    
    init(weather: String, icon: String, location: String) {
        self.weather = weather
        self.icon = icon
        self.location = location
    }
}
