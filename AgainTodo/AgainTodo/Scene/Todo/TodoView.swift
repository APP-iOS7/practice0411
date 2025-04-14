

import SwiftUI
import SwiftData

struct TodoView: View {
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel: TodoViewModel

    init(context: ModelContext) {
        _viewModel = ObservedObject(wrappedValue: TodoViewModel(context: context))
    }

    var body: some View {
        NavigationStack{
            VStack(alignment: .leading) {
                ScrollView {
                    ForEach(viewModel.todos.indices, id: \.self) {index in
                        NavigationLink(destination: TodoDetailView(todo: viewModel.todos[index])) {
                            HStack {
                                if viewModel.showSelectBox {
                                    Button(
                                        action: {viewModel.addTodoListToSelectedBox(index)},
                                        label: {
                                            Image(systemName: viewModel.isSelectedTodoList(index: index) ? "checkmark.square.fill" : "square")
                                                .id(viewModel.isUpdateUI)
                                        })
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
                if viewModel.showSelectBox {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { viewModel.deleteSelectedTodoList() }, label: {Image(systemName: "trash")})
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { viewModel.saveSelectedTodoList() }, label: {Image(systemName: "checklist")})
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { viewModel.showSelectBox.toggle() }, label: {Image(systemName: viewModel.showSelectBox ? "xmark.circle" : "checkmark.circle")})
                }
                
                if !viewModel.showSelectBox {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button(action: { viewModel.showAddTodoView.toggle() }, label: {Image(systemName: "plus")})
                    }
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddTodoView, onDismiss: {viewModel.fetchTodos()}, content: { AddTodoView(context: modelContext) })
        .onAppear {
            LocationManager().requestLocation()
        }
    }
    
    
}
