import SwiftUI
import SwiftData

struct CategoryDetailView: View {
    @State var category: Category
    @State var editMode = EditMode.inactive
    @Binding var path: NavigationPath
    @Environment(\.modelContext) private var modelContext
    @State private var categoryName: String
    @State private var showingNewUnitSheet = false
    @State private var showingCustomConversionSheet = false
    
    init(category: Category, path: Binding<NavigationPath>) {
        self.category = category
        _path = path
        _categoryName = State(initialValue: category.name)
    }
    
    var body: some View {
        VStack {
            if !category.isSystemDefined {
                HStack {
                    TextField("Category Name", text: $categoryName)
                        .font(.headline)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .onChange(of: categoryName) { _, newValue in
                            category.name = newValue
                        }
                    
                    Button {
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                    }
                }
                .padding(.horizontal)
            }
            
            List {
                Section {
                    ForEach(category.units.filter({ !$0.isSystemDefined })) { unit in
                        NavigationLink(value: unit, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(unit.name)
                                        .fontWeight(.medium)
                                    Text("Factor: \(unit.factor.description)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text(unit.symbol)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                            }
                        })
                    }
                    .onDelete { indexSet in
                        let userUnits = category.units.filter { !$0.isSystemDefined }
                        for index in indexSet {
                            if index < userUnits.count {
                                let unitToRemove = userUnits[index]
                                if let actualIndex = category.units.firstIndex(where: { $0.id == unitToRemove.id }) {
                                    category.units.remove(at: actualIndex)
                                    modelContext.delete(unitToRemove)
                                }
                            }
                        }
                    }
                    
                    Button {
                        showingNewUnitSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.blue)
                            Text("Add New Unit")
                                .foregroundColor(.blue)
                        }
                    }
                } header: {
                    Text("Your Units")
                }
                
                if !category.isSystemDefined {
                    Button {
                        showingCustomConversionSheet = true
                    } label: {
                        HStack {
                            Image(systemName: "function")
                                .foregroundColor(.blue)
                            Text("Create Custom Conversion")
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                if category.isSystemDefined {
                    Section {
                        ForEach(category.units.filter(\.isSystemDefined)) { unit in
                            NavigationLink(value: unit, label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(unit.name)
                                            .fontWeight(.medium)
                                        Text("Factor: \(unit.factor.description)")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text(unit.symbol)
                                        .fontWeight(.medium)
                                        .foregroundColor(.secondary)
                                }
                            })
                        }
                    } header: {
                        Text("System-Defined Units")
                    } footer: {
                        Text("System-defined units cannot be modified or deleted.")
                            .font(.caption)
                    }
                }
            }
        }
        .navigationBarTitle(category.isSystemDefined ? category.name : "Edit Category")
        .navigationBarTitleDisplayMode(category.isSystemDefined ? .automatic : .inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
            }
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: $showingNewUnitSheet) {
            UnitDetailView(unit: Unit(category))
        }
        .sheet(isPresented: $showingCustomConversionSheet) {
            CustomConversionCreatorView(category: category)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let category = Category(name: "Preview Category")
    category.units.append(Unit(category: category, name: "System-Defined Unit", symbol: "s", useMetricPrefixes: false, factor: 1, numerator: [], denominator: []))
    return CategoryDetailView(category: category, path: $path)
}
