//
//  Item.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/11/25.
//

import Foundation
import SwiftData

@Model
final class TodoItem: Identifiable {
    var title: String = ""
    var id: UUID
    var createdAt: Date?
    var isCompleted: Bool = false
    var category: String?
    
    
    init(
        title: String,
        id: UUID = UUID(),
        createdAt: Date?,
        isCompleted: Bool = false,
        category: String? = nil
    ) {
        self.title = title
        self.id = id
        self.createdAt = createdAt
        self.isCompleted = isCompleted
        self.category = category
    }
}
