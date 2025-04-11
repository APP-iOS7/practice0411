//
//  AddTodoViewModel.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import Foundation


final class AddTodoViewModel: ObservableObject {
    private var modelManager: TodoModelManager = .shared
    
    @Published var title: String = ""
    @Published var detail: String = ""
    @Published var showDatePicker: Bool = false
    @Published var date: Date = Date()
    
    func saveTodo() {
        let weatherItem = Weather(weather: "test", icon: "cloud.rain", location: "test location")
        let todoItem = Todo(title: title, detail: detail, deadline: showDatePicker ? date : nil, weather: weatherItem)
        
        modelManager.insertTodo(todoItem)
        
    }
}
