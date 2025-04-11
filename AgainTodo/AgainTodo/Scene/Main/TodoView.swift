

import SwiftUI

struct TodoView: View {
    @ObservedObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack{
            VStack {
                ForEach(viewModel.fetchTodos()) {item in
                    NavigationLink(destination: TodoDetailView()) {
                        TodoItemView()
                    }
                }
                Spacer()
            }
            .navigationTitle(Text("Todo"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showAddTodoView.toggle() }, label: {Image(systemName: "plus")})
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddTodoView, content: { AddTodoView() })
    }
    
}

#Preview {
    TodoView()
}
