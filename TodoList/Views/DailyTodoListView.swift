//
//  DailyTodoList.swift
//  TodoList
//
//  Created by Yung Hak Lee on 4/13/25.
//

import SwiftUI
import SwiftData

struct DailyTodoListView: View {
    @StateObject private var viewModel: DailyTodoListViewModel
    @Environment(\.modelContext) private var modelContext
    
    init(modelContext: ModelContext) {
        _viewModel = StateObject(wrappedValue: DailyTodoListViewModel(modelContext: modelContext))
    }
    
    var body: some View {
        VStack(spacing: 0) {
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
                .tint(.white)
                .padding(.vertical, 10)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            TextField("Search Daily Todos...", text: $viewModel.searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
            
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemBackground))
                    .padding(.horizontal)
                
                List {
                    if viewModel.filteredItems.isEmpty {
                        Text("No daily todos found.")
                            .foregroundStyle(.gray)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ForEach(viewModel.filteredItems) { item in
                            HStack {
                                Button(action: {
                                    viewModel.toggleCompleted(for: item)
                                }) {
                                    Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                                        .foregroundColor(item.isCompleted ? .teal : .gray)
                                }
                                Text(item.title)
                                    .strikethrough(item.isCompleted)
                                
                                Spacer()
                            }
                        }
                        .onDelete(perform: viewModel.removeDailyTodo)
                    }
                }
                .scrollContentBackground(.hidden)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding()
        }
        .navigationTitle("Daily Todo List")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddDailyTodoView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear {
            viewModel.fetchDailyTodoItems()
        }
        .background(Color.teal.edgesIgnoringSafeArea(.all))
    }
}
