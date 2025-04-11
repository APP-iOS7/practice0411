//
//  Todo.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import Foundation
import SwiftData

@Model
final class Todo: Identifiable, Equatable, ObservableObject {
    var id: UUID
    var title: String
    var detail: String
    var deadline: Date?
    var isDone: Bool
    var weather: Weathers?
    
    init(title: String = "", detail: String = "", deadline: Date? = nil, isDone: Bool = false, weather: Weathers? = nil) {
        self.id = UUID()
        self.title = title
        self.detail = detail
        self.deadline = deadline
        self.isDone = isDone
        self.weather = weather
    }
    
    static func empty() -> Todo {
        return Todo(title: "empty todo", detail: "empty detail", deadline: Date(), isDone: false, weather: nil)
    }
}
