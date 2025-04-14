//
//  DailyTodoListModel.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/13/25.
//

import Foundation
import SwiftData

@Model
class DailyTodoItem {
    var title: String
    var category: String?
    var isCompleted: Bool
    
    init(title: String, category: String? = nil, isCompleted: Bool = false) {
        self.title = title
        self.category = category
        self.isCompleted = isCompleted
    }
}
