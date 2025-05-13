import SwiftUI
import SwiftData

struct CustomiseView: View {
    @StateObject private var model = CustomiseViewModel()
    @Query(sort: \Category.name) private var categories: [Category]
    @Environment(\.modelContext) private var modelContext
    @State private var showingNewCategorySheet = false
    @State private var newCategoryName = ""
    
    var body: some View {
        NavigationStack(path: $model.path) {
            List {
                Section {
                    ForEach(categories.filter { !$0.isSystemDefined }) { category in
                        NavigationLink(value: category, label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text("\(category.units.count) units")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        })
                    }
                    .onDelete { indexSet in
                        let userCategories = categories.filter { !$0.isSystemDefined }
                        for index in indexSet {
                            if index < userCategories.count {
                                let categoryToRemove = userCategories[index]
                                for unit in categoryToRemove.units.filter({ !$0.isSystemDefined }) {
                                    modelContext.delete(unit)
                                }
                                modelContext.delete(categoryToRemove)
                            }
                        }
                    }
                    
                    Button {
                        showingNewCategorySheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add New Category")
                                .foregroundColor(.blue)
                        }
                    }
                } header: {
                    Text("Your Categories")
                } footer: {
                    Text("Create custom categories and units for your specific conversion needs.")
                }
                
                Section {
                    ForEach(categories.filter(\.isSystemDefined)) { category in
                        NavigationLink(value: category, label: {
                            HStack {
                                Text(category.name)
                                Spacer()
                                Text("\(category.units.count) units")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        })
                    }
                } header: {
                    Text("System-Defined Categories")
                } footer: {
                    Text("These built-in categories provide common conversion options. You can view but not edit them.")
                }
            }
            .navigationBarTitle("Categories")
            .navigationDestination(for: Category.self) { category in
                CategoryDetailView(category: category, path: $model.path)
            }
            .navigationDestination(for: Unit.self) { unit in
                UnitDetailView(unit: unit)
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, $model.editMode)
            .sheet(isPresented: $showingNewCategorySheet) {
                NavigationView {
                    VStack {
                        Form {
                            Section {
                                TextField("Category Name", text: $newCategoryName)
                                    .autocapitalization(.words)
                            } header: {
                                Text("New Category Details")
                            }
                        }
                        
                        Button {
                            if !newCategoryName.isEmpty {
                                let category = Category()
                                category.name = newCategoryName
                                modelContext.insert(category)
                                newCategoryName = ""
                                showingNewCategorySheet = false
                                model.path.append(category)
                            }
                        } label: {
                            Text("Create Category")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(newCategoryName.isEmpty ? Color.gray : Color.blue)
                                .cornerRadius(10)
                                .padding(.horizontal)
                        }
                        .disabled(newCategoryName.isEmpty)
                    }
                    .navigationBarTitle("New Category", displayMode: .inline)
                    .navigationBarItems(trailing: Button("Cancel") {
                        showingNewCategorySheet = false
                        newCategoryName = ""
                    })
                }
            }
        }
    }
}

#Preview {
    CustomiseView()
        .modelContainer(previewContainer)
}
