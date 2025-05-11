import SwiftUI
import SwiftData

struct CustomiseView: View {
    @StateObject private var model = CustomiseViewModel()
    @Query private var categories: [Category]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack(path: $model.path) {
            List {
                ForEach(categories) { category in
                    NavigationLink(value: category, label: {
                        Text(category.name)
                    })
                    .deleteDisabled(category.isSystemDefined)
                }
                .onDelete { deleted in
                    for i in deleted {
                        modelContext.delete(categories[i])
                    }
                }
                if (model.editMode == .inactive) {
                    Button {
                        let category = Category()
                        modelContext.insert(category)
                        model.path.append(category)
                    } label: {
                        Text("Add Category...")
                    }
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
}
