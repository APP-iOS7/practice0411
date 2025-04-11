//
//  WeatherData.swift
//  WeatherApp
//
//  Created by NO SEONGGYEONG on 4/11/25.
//

struct WeatherData: Codable {
    
    /// 섭씨 온도
    var temperature: Double
    
    /// 날씨 설명
    var description: String
    
    /// 습도
    var humdity: Double
    
    /// 풍속
    var windSpeed: Double
    
    /// 날씨에 맞는 옷차림
    var clothes: String
    
    static let empty = WeatherData(temperature: 0, description: "", humdity: 0, windSpeed: 0, clothes: "")
}
