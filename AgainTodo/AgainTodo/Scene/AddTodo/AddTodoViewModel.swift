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
        let weatherItem = Weather(weather: "test", icon: "cloud.rain", location: "test location")
        let todoItem = Todo(title: title, detail: detail, deadline: showDatePicker ? date : nil, weather: weatherItem)
        
        modelManager.insertTodo(todoItem)
        
    }
}
