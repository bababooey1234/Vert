import SwiftUI

struct CategoryDetailView: View {
    @State var category: Category
    @State var editMode = EditMode.inactive
    @Binding var path: NavigationPath
    var body: some View {
        List {
            ForEach(category.units) { unit in
                NavigationLink {
                    UnitDetailView(unit: unit)
                } label: {
                    Text("\(unit.name) (\(unit.symbol))")
                }
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
        let unit = Unit(category: category)
        category.units.append(unit)
        print(path)
        print(path.count)
        path.append(unit)
        print(path)
        print(path.count)
    }
}

#Preview {
    struct Preview: View {
        @State var path = NavigationPath()
        var body: some View {
            NavigationStack(path: $path) {
                CategoryDetailView(category: categories[0], path: $path)
            }
        }
    }
    
    return Preview()
}
