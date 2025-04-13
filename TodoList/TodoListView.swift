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
                                        .foregroundStyle(.black)
                                    Picker("Category", selection: $viewModel.selectedCategory) {
                                        Text("All").tag(String?.none)
                                        ForEach(viewModel.uniqueCategories(), id: \.self) { category in
                                            Text(category).tag(String?.some(category))
                                        }
                                    }
                                    .pickerStyle(.menu)
                                    .tint(.black)
                                    .padding(.vertical, 10)
                                }
                                .padding(.horizontal)
                
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
            .background(Color.teal.edgesIgnoringSafeArea(.all))
        }
    }
}
