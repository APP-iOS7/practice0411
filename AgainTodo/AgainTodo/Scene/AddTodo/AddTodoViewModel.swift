//
//  AddTodoViewModel.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import Foundation


final class AddTodoViewModel: ObservableObject {
    @Published var title: String = ""
    @Published var detail: String = ""
    @Published var showDatePicker: Bool = false
    @Published var date: Date = Date()
    
    func saveTodo() {
        
    }
}
