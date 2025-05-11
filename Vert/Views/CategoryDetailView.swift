import SwiftUI

struct CategoryDetailView: View {
    @State var category: Category
    @State var editMode = EditMode.inactive
    @Binding var path: NavigationPath
    var body: some View {
        List {
            Section {
                ForEach(category.units.filter({ !$0.isSystemDefined })) { unit in
                    NavigationLink(value: unit, label: {
                        Text("\(unit.name) (\(unit.symbol))")
                    })
                }
                .onDelete { deleted in
                    //TODO: Fix
                    category.units.remove(atOffsets: deleted)
                }
                
                Button {
                    let unit = Unit(category)
                    category.units.append(unit)
                    path.append(unit)
                } label: {
                    Text("Add Unit...")
                }
            } header: {
                Text("Your Units")
            }
            if category.isSystemDefined {
                Section {
                    ForEach(category.units.filter(\.isSystemDefined)) { unit in
                        NavigationLink(value: unit, label: {
                            Text("\(unit.name) (\(unit.symbol))")
                        })
                    }
                } header: {
                    Text("System-Defined Units")
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
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let category = Category(name: "Preview Category")
    category.units.append(Unit(category: category, name: "System-Defined Unit", symbol: "s", useMetricPrefixes: false, factor: 1, numerator: [], denominator: []))
    return CategoryDetailView(category: category, path: $path)
}
