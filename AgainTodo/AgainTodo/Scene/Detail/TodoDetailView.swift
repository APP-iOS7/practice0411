//
//  TodoDetailView.swift
//  AgainTodo
//
//  Created by 고요한 on 4/11/25.
//

import SwiftUI

struct TodoDetailView: View {
    let todo: Todo
    
    var body: some View {
        Text(todo.title)
        Text(todo.detail)
        Text(todo.deadline?.description ?? "")
        Text(todo.isDone ? "Done" : "Not Done")
    }
}

#Preview {
    TodoDetailView(todo: Todo.empty())
}
