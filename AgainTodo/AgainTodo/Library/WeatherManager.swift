
import Foundation
import WeatherKit
import CoreLocation


class WeatherManager {
    private var locationManager = LocationManager()
    private let service = WeatherService()
    private var weather: Weather?
    
    func getDayWeather(day date: Date, for location: CLLocation) async -> DayWeather? {
        do {
            let weather = try await service.weather(for: location)
            let forecast = weather.dailyForecast
            if let dayWeather = getWeather(for: date, from: forecast) {
                return dayWeather
            }
        }
        catch {
            print("WEAHTER ERROR: \(error)")
            return nil
        }
        return nil
    }
    
    func getWeather(for date: Date, from forecast: Forecast<DayWeather>) -> DayWeather? {
        let calendar = Calendar.current
        return forecast.forecast.first(where: { dayWeather in
            calendar.isDate(dayWeather.date, inSameDayAs: date)
        })
    }
    
    
    func decodingToWeatherModel(_ data: DayWeather) {
        
    }
}
