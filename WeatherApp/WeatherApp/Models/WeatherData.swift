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
    
    
    init(temperature: Double, description: String, humdity: Double, windSpeed: Double, clothes: String) {
        self.temperature = temperature
        self.description = description
        self.humdity = humdity
        self.windSpeed = windSpeed
        self.clothes = clothes
    }
    
    static let empty = WeatherData(temperature: 0, description: "", humdity: 0, windSpeed: 0, clothes: "날씨를 불러오는데 에러가 발생했습니다.")
}
