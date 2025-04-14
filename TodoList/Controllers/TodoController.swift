//
//  TodoController.swift
//  TodoList
//
//  Created by Jungman Bae on 4/14/25.
//
import SwiftData
import Foundation

class TodoController {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: 새 할일 추가
    func addTodo(withItem item: TodoItem) {
        modelContext.insert(item)
        saveContext()
    }
    
    //MARK: 할 일 제거
    func removeTodo(withItems items: [TodoItem]) {
        for item in items {
            modelContext.delete(item)
        }
        saveContext()
    }
    
    // MARK: 완료 된 것 지우기
    func changeComplete(for item: TodoItem, isCompleted: Bool = true) {
        item.isCompleted = isCompleted
        saveContext()
    }
    
    // MARK: 저장 공통 로직
    private func saveContext() {
        do {
            try modelContext.save()
        } catch {
            print("save failed: \(error)")
        }
    }
    
    
}
