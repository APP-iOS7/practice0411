
import SwiftData
import WeatherKit
import CoreLocation


@Model
class Weathers {
    var weather: String
    var icon: String
    var latitude: Double
    var longitude: Double
    var maxTemp: Double
    var minTemp: Double
    var precipitationChance: Double
    var uvValue: Int
    var uvCategory: String
    
    init(weather: String, icon: String, latitude: Double, longitude: Double, maxTemp: Double, minTemp: Double, precipitationChance: Double, uvValue: Int, uvCategory: String) {
        self.weather = weather
        self.icon = icon
        self.latitude = latitude
        self.longitude = longitude
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.precipitationChance = precipitationChance
        self.uvValue = uvValue
        self.uvCategory = uvCategory
    }
    
    static func empty() -> Weathers {
        return Weathers(
            weather: "empty weather",
            icon: "cloud.rain",
            latitude: 0.0,
            longitude: 0.0,
            maxTemp: 0.0,
            minTemp: 0.0,
            precipitationChance: 0.0,
            uvValue: 0,
            uvCategory: "높음"
        )
    }
    
    static func makeModel(data: DayWeather, location: CLLocation) -> Weathers {
        let conditionAndIconString = WeatherConditions.getConditionAndIcon(codition: String(describing: data.condition))
        let maxTemp = data.highTemperature.value
        let minTemp = data.lowTemperature.value
        let precipitationChance = data.precipitationChance
        let uvIndex = data.uvIndex

        let weatherItem = Weathers(weather: conditionAndIconString.conditionString, icon: conditionAndIconString.iconName, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, maxTemp: maxTemp, minTemp: minTemp, precipitationChance: precipitationChance, uvValue: uvIndex.value, uvCategory: UVIndexCategory.getCategory(uvCategory: uvIndex.category.rawValue))
        return weatherItem
        
    }
}
