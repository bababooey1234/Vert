import SwiftUI

struct CategoryDetailView: View {
    @State var category: Category
    @State var editMode = EditMode.inactive
    @Binding var path: NavigationPath
    var body: some View {
        List {
            ForEach(category.units) { unit in
                NavigationLink(value: unit, label: {
                    Text("\(unit.name) (\(unit.symbol))")
                })
                .deleteDisabled(unit.isSystemDefined)
            }
            .onDelete { deleted in
                category.units.remove(atOffsets: deleted)
            }
            
            if (editMode == .inactive) {
                Button(action: addNewUnit) {
                    Text("Add Unit...")
                }
            }
        }
        .navigationBarTitle(category.name)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .environment(\.editMode, $editMode)
    }
    
    private func addNewUnit() {
        let unit = Unit(category)
        category.units.append(unit)
        path.append(unit)
    }
}

#Preview {
    struct Preview: View {
        @State var path = NavigationPath()
        var body: some View {
            NavigationStack(path: $path) {
                CategoryDetailView(category: Category(name: "Preview Category"), path: $path)
            }
        }
    }
    
    return Preview()
}
