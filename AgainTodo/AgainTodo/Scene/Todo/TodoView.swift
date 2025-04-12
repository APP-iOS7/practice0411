//TODO: font 정리

import SwiftUI

struct TodoView: View {
    @ObservedObject private var viewModel = TodoViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(viewModel.todos.indices, id: \.self) {index in
                        NavigationLink(destination: TodoDetailView(todo: viewModel.todos[index])) {
                            HStack {
                                if viewModel.showCheckBox {
                                    Toggle("", systemImage: viewModel.todos[index].isDone ? "checkmark.square.fill" : "square",isOn: $viewModel.todos[index].isDone)
                                        .labelsHidden()
                                        .frame(width: 30, height: 30)
                                        .toggleStyle(.button)
                                        .background(.clear)
//Combine사용으로 필요 없는 부분
//                                        .onChange(of: viewModel.todos[index].isDone) {
//                                            viewModel.updateTodo(viewModel.todos[index])
//                                        }
                                        
                                }
                                TodoItemView(todoItem: viewModel.todos[index])
                                Spacer()
                            }
                            .background(viewModel.todos[index].isDone ? .gray : .clear)
                        }
                        .foregroundStyle(.black)
                        .contextMenu {
                            Button(action: {print("수정하기!")}, label: {Label("수정하기", systemImage: "square.and.pencil")})
                            Button(action: {
                                viewModel.deleteTodo(viewModel.todos[index])
                                viewModel.fetchTodos()
                            }, label: {Label("삭제하기", systemImage: "trash")})
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
            .navigationTitle(Text("Todo"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showCheckBox.toggle() }, label: {Image(systemName: "checkmark.circle")})
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showAddTodoView.toggle() }, label: {Image(systemName: "plus")})
                }
                
            }
        }
        .sheet(isPresented: $viewModel.showAddTodoView, onDismiss: {viewModel.fetchTodos()}, content: { AddTodoView() })
        .onAppear {
            LocationManager().requestLocation()
        }
    }
    
    
}

#Preview {
    TodoView()
}
