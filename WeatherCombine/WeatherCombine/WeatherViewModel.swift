//
//  WeatherService.swift
//  WeatherCombine
//
//  Created by 멘태 on 4/11/25.
//

import Combine
import CoreLocation
import WeatherKit

final class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    @Published var isLoading: Bool
    @Published var error: Error?
    
    var cancellables = Set<AnyCancellable>()
    
    private var subject = PassthroughSubject<CLLocation, Error>()
    
    init(weather: WeatherData? = nil, isLoading: Bool = false, error: Error? = nil) {
        self.weather = weather
        self.isLoading = isLoading
        self.error = error
        
        subject
            .flatMap { location in
                Future<CurrentWeather, Error> { promise in
                    Task {
                        do {
                            let weather = try await WeatherService().weather(for: location).currentWeather
                            promise(.success(weather))
                        } catch {
                            promise(.failure(error))
                        }
                    }
                }
            }
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.error = error
                    debugPrint("[Error] 날씨 정보 조회 오류: ", error.localizedDescription)
                }
            } receiveValue: { [weak self] weather in
                self?.weather = WeatherData(weather: weather)
            }
            .store(in: &cancellables)
    }
    
    func fetchWeather(location: CLLocation) {
        subject.send(location)
    }
}
