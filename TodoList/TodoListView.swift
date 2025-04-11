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
            VStack {
                HStack {
                    Text("Category:")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                Picker("Category", selection: $selectedCategoryFilter) {
                    Text("All").tag(String?.none)
                    ForEach(viewModel.uniqueCategories(), id: \.self) { category in
                        Text(category).tag(String?.some(category))
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedCategoryFilter) { oldValue, newValue in
                    viewModel.selectedCategory = newValue
                }
                .onChange(of: viewModel.selectedCategory) { _, newValue in
                    selectedCategoryFilter = newValue
                }
                .frame(maxWidth: 200, maxHeight: 50)
                .clipped()
            }
                .padding(.horizontal)
                List {
                    ForEach(viewModel.filteredItems) { item in
                        HStack {
                            Button(action: {
                                viewModel.toggleCompleted(for: item)
                            }) {
                                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(item.isCompleted ? .blue : .gray)
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
                            } else {
                                Text("No date")
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
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.fetchTodoItems()
            }
        }
    }
}
