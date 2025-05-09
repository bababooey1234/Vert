import SwiftUI

struct CustomiseView: View {
    @StateObject var model = CustomiseViewModel()
    var body: some View {
        NavigationStack(path: $model.path) {
            List {
                ForEach(model.categoriesCopy) { category in
                    NavigationLink(value: category, label: {
                        Text(category.name)
                    })
                }
                .onDelete { deleted in
                    model.categoriesCopy.remove(atOffsets: deleted)
                }
                if (model.editMode == .inactive) {
                    Button(action: model.addNewCategory) {
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
