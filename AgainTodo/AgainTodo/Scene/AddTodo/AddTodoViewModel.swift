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
    
    @Published var title: String = ""
    @Published var detail: String = ""
    @Published var showDatePicker: Bool = false
    @Published var date: Date = Date()
    @Published var isFormValid: Bool = false
    
    init() {
        Publishers.CombineLatest($title, $detail)
            .map {
                print("\($0) , \($1)")
                print(!$0.trimmingCharacters(in: .whitespaces).isEmpty && !$1.trimmingCharacters(in: .whitespaces).isEmpty)
                return !$0.trimmingCharacters(in: .whitespaces).isEmpty && !$1.trimmingCharacters(in: .whitespaces).isEmpty }
            .assign(to: &$isFormValid)
    }
    
    func saveTodo() {
        let weatherItem = Weather(weather: "test", icon: "cloud.rain", location: "test location")
        let todoItem = Todo(title: title, detail: detail, deadline: showDatePicker ? date : nil, weather: weatherItem)
        
        modelManager.insertTodo(todoItem)
        
    }
}
