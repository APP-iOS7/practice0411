//
//  WeatherService.swift
//  WeatherApp
//
//  Created by NO SEONGGYEONG on 4/11/25.
//

import Foundation
import WeatherKit
import CoreLocation

class MyWeatherService: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var weatherKit: Weather?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // 위치 정확도 설정
        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            // requestWhenInUseAuthorization() 에 대한 설명 :
            // 사용자가 앱을 처음 실행할 때 위치 권한을 요청합니다. 사용자가 위치 권한을 허용하면, 앱은 위치 업데이트를 시작합니다.
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    func fetchWeather(for location: CLLocation) async throws -> WeatherData {
        do {
            // WeatherKit의 WeatherService.shared.weather(for: location) 메소드를 사용하여 날씨 정보를 가져오는 코드입니다.
            let weather = try await WeatherService.shared.weather(for: location)
            let temperature = weather.currentWeather.temperature.value
            let description = weather.currentWeather.condition.description
            let humdity = weather.currentWeather.humidity
            let windSpeed = weather.currentWeather.wind.speed.value
            let weatherData = WeatherData(
                temperature: temperature,
                description: description,
                humdity: humdity,
                windSpeed: windSpeed,
                clothes: recommendClothes(temperature: temperature))
            return weatherData
        } catch {
            print("fetchWeather 에서 에러 발생: \(error)")
            return WeatherData.empty
        }
    }
    
    func recommendClothes(temperature: Double) -> String {
        if (-10..<0).contains(temperature) {
            return "두꺼운 패딩이나 롱패딩, 내복, 니트, 기모 바지, 방한용 장갑, 목도리, 모자 착용이 필요합니다."
        } else if (0..<10).contains(temperature) {
            return "쌀쌀한 날씨입니다. 패딩이나 두꺼운 코트, 니트, 기모 있는 바지, 장갑 착용이 좋습니다. 바람이 강할 경우 목도리나 모자도 착용하세요."
        } else if (10..<20).contains(temperature) {
            return "서늘한 날씨입니다. 가벼운 코트, 가죽 자켓, 니트나 맨투맨, 긴바지 착용이 적당합니다. 아침, 저녁으로는 쌀쌀할 수 있으니 겉옷을 챙기세요."
        } else if (20..<30).contains(temperature) {
            return "따뜻하거나 약간 더운 날씨입니다. 반팔 티셔츠, 얇은 셔츠, 가벼운 바지나 반바지가 적당합니다. 햇빛이 강하면 모자나 선글라스도 추천됩니다."
        } else if (30..<40).contains(temperature) {
            return "매우 더운 날씨입니다. 통풍 잘 되는 민소매, 반팔, 반바지 등 시원한 복장을 착용하세요. 땀 흡수가 잘 되는 옷, 모자, 썬크림도 필수입니다."
        } else {
            return "비정상 적인 날씨입니다. 외출하지 않으시는 것을 권장드립니다."
        }
    }
    
    func getCurrentLocation() -> CLLocation? {
        return currentLocation
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        self.currentLocation = lastLocation
        
        print("위치 업데이트: \(lastLocation.coordinate.latitude), \(lastLocation.coordinate.longitude)")
        locationManager.stopUpdatingLocation()
    }
}
