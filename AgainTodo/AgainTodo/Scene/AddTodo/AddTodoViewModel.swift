//
//  AddTodoViewModel.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import Foundation
import Combine


final class AddTodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    private var locationManager = LocationManager()
    private var weatherManager = WeatherManager()
    
    @Published var title: String = ""
    @Published var detail: String = ""
    @Published var showDatePicker: Bool = false
    @Published var date: Date = Date()
    @Published var isFormValid: Bool = false
    
    init() {
        Publishers.CombineLatest($title, $detail)
            .map {
                return !$0.trimmingCharacters(in: .whitespaces).isEmpty && !$1.trimmingCharacters(in: .whitespaces).isEmpty }
            .assign(to: &$isFormValid)
    }
    
    func saveTodo() {
        locationManager.requestLocation()
        if let location = locationManager.location {
            Task{
                var weatherModel : Weathers?
                if showDatePicker, let result = await weatherManager.getDayWeather(day: date, for: location)  {
                    weatherModel = Weathers.makeModel(data: result, location: location)
                }
                else { weatherModel = nil}
                
                
                let todoItem = Todo(title: title, detail: detail, deadline: showDatePicker ? date.addingTimeInterval(32400) : nil, weather: showDatePicker ? weatherModel : nil)
                
                modelManager.insertTodo(todoItem)
            }
        }
        else {
            let todoItem = Todo(title: title, detail: detail, deadline: showDatePicker ? date.addingTimeInterval(32400) : nil, weather: nil)
            
            modelManager.insertTodo(todoItem)
        }
    }
    
}
