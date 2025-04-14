//
//  AddTodoViewModel.swift
//  TodoList
//
//  Created by Jungman Bae on 4/14/25.
//

import Foundation
import SwiftData

class AddTodoViewModel: ObservableObject {
    private let controller: TodoController

    @Published var categories: [String] = []

    init(modelContext: ModelContext) {
        self.controller = TodoController(modelContext: modelContext)
        fetchCategories()
    }

    // MARK: 카테고리 가져오기
    func fetchCategories() {
        categories = controller.fetchCategories()
    }

    // MARK: 새 할일 추가
    func addTodo(title: String, createdAt: Date?, category: String?) {
        guard !title.isEmpty else { return }
        let newItem = TodoItem(title: title, createdAt: createdAt, isCompleted: false,
                               category: category)
        controller.addTodo(withItem: newItem)
    }

}
