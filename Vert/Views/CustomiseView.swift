import SwiftUI
import SwiftData

struct CustomiseView: View {
    @StateObject private var model = CustomiseViewModel()
    @Query private var categories: [Category]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack(path: $model.path) {
            List {
                Section {
                    ForEach(categories.filter { !$0.isSystemDefined }) { category in
                        NavigationLink(value: category, label: {
                            Text(category.name)
                        })
                    }
                    .onDelete { deleted in
                        for i in deleted {
                            modelContext.delete(categories.filter { !$0.isSystemDefined }[i])
                        }
                    }
                    Button {
                        let category = Category()
                        modelContext.insert(category)
                        model.path.append(category)
                    } label: {
                        Text("Add Category...")
                    }
                } header: {
                    Text("Your Categories")
                }
                Section {
                    ForEach(categories.filter(\.isSystemDefined)) { category in
                        NavigationLink(value: category, label: {
                            Text(category.name)
                        })
                    }
                } header: {
                    Text("System-Defined Categories")
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
        }
    }
}

#Preview {
    CustomiseView()
        .modelContainer(previewContainer)
}
