//
//  Color+Extensions.swift
//  WeatherApp
//
//  Created by KimJunsoo on 4/11/25.
//

import SwiftUI

extension Color {
    // HEX 문자열로부터 Color 생성 ("#E7EEFF")
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (예: E7EEFF)
            (r, g, b) = (
                (int >> 16) & 0xFF,
                (int >> 8) & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (1, 1, 1) // 오류 방지용 기본값
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1.0
        )
    }
}
