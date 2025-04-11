

import SwiftUI

struct TodoView: View {
    @ObservedObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ForEach([Todo.empty()]) {item in
                    NavigationLink(destination: TodoDetailView()) {
                        TodoItemView(todoItem: item)
                    }
                    .foregroundStyle(.black)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle(Text("Todo"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showAddTodoView.toggle() }, label: {Image(systemName: "plus")})
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddTodoView, content: { AddTodoView() })
        .onAppear() {
            viewModel.fetchTodos()
        }
    }
    
}

#Preview {
    TodoView()
}
