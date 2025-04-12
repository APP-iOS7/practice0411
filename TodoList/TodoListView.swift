//
//  TodoListView.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/11/25.
//

import SwiftUI
import SwiftData

struct TodoListView: View {
    @StateObject private var viewModel: TodoListViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var selectedCategoryFilter: String? = nil
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: TodoListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing:0) {
                TextField("Search TodoList...", text: $viewModel.searchText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                HStack {
                    Text("Category:")
                        .font(.headline)
                    Menu {
                        Button("All") {
                            viewModel.selectedCategory = nil
                        }
                        ForEach(viewModel.uniqueCategories(), id: \.self) { category in
                            Button(category) {
                                viewModel.selectedCategory = category
                            }
                        }
                    } label: {
                        Text(viewModel.selectedCategory ?? "All")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    .padding()
                }
                List {
                    ForEach(viewModel.filteredItems) { item in
                        HStack {
                            Button(action: {
                                viewModel.toggleCompleted(for: item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .indigo : .gray)
                            }
                            Text(item.title)
                                .strikethrough(item.isCompleted)
                            
                            Spacer()
                            if let createdAt = item.createdAt {
                                Text(createdAt, style: .date)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(createdAt, style: .time)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .onDelete(perform: viewModel.removeTodo)
                }
            }
            .navigationTitle("Todo List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: AddTodoView(viewModel: viewModel)) {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                    }
                }
            }
            .onAppear {
                viewModel.fetchTodoItems()
            }
            .background(Color.indigo.edgesIgnoringSafeArea(.all))
        }
    }
}
