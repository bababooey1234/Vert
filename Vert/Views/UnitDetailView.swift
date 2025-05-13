import SwiftUI
import SwiftData

struct UnitDetailView: View {
    @State var unit: Unit
    @State private var name: String
    @State private var symbol: String
    @State private var factor: String
    @State private var formula: String
    @State private var showingHelp = false
    @State private var showingFormulaHelp = false
    @State private var formulaIsValid = true
    @Environment(\.dismiss) private var dismiss
    
    init(unit: Unit) {
        self.unit = unit
        _name = State(initialValue: unit.name)
        _symbol = State(initialValue: unit.symbol)
        _factor = State(initialValue: unit.factor.description)
        _formula = State(initialValue: unit.conversionFormula ?? "")
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .onChange(of: name) { _, newValue in
                        unit.name = newValue
                    }
                    .autocapitalization(.words)
                
                TextField("Symbol", text: $symbol)
                    .onChange(of: symbol) { _, newValue in
                        unit.symbol = newValue
                    }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Conversion Factor")
                        Spacer()
                        Button {
                            showingHelp.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    TextField("Conversion Factor", text: $factor)
                        .keyboardType(.decimalPad)
                        .onChange(of: factor) { _, newValue in
                            if let decimalValue = Decimal(string: newValue) {
                                unit.factor = decimalValue
                            }
                        }
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Custom Conversion Formula")
                        Spacer()
                        Button {
                            showingFormulaHelp.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                    }
                    
                    TextField("e.g., x * 9/5 + 32", text: $formula)
                        .onChange(of: formula) { _, newValue in
                            if newValue.isEmpty {
                                unit.conversionFormula = nil
                                formulaIsValid = true
                            } else {
                                formulaIsValid = FormulaEvaluator.isValid(formula: newValue)
                                if formulaIsValid {
                                    unit.conversionFormula = newValue
                                }
                            }
                        }
                        .foregroundColor(formulaIsValid ? .primary : .red)
                    
                    if !formulaIsValid {
                        Text("Invalid formula")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            } header: {
                Text("Unit Details")
            }
            
            if showingHelp {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to set the conversion factor:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("The conversion factor tells how to convert between this unit and the base unit in the category.")
                            .font(.caption)
                        
                        Text("Examples:")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("• If meter is base (1.0), kilometer would be 1000")
                            .font(.caption)
                        
                        Text("• If second is base (1.0), minute would be 60")
                            .font(.caption)
                        
                        Text("• If meter is base (1.0), centimeter would be 0.01")
                            .font(.caption)
                    }
                } header: {
                    Text("Help")
                }
            }
            
            if showingFormulaHelp {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("How to use custom formulas:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Text("Create a formula using the variable 'x' to represent the input value.")
                            .font(.caption)
                        
                        Text("Examples:")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("• For Fahrenheit: x * 9/5 + 32")
                            .font(.caption)
                        
                        Text("• For Celsius: (x - 32) * 5/9")
                            .font(.caption)
                        
                        Text("Supported operators: +, -, *, /, (), Math.pow(x,y)")
                            .font(.caption)
                        
                        Text("If you leave this empty, the standard conversion factor will be used.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                } header: {
                    Text("Formula Help")
                }
            }
            
            if !unit.isSystemDefined {
                Section {
                    Button {
                        if !name.isEmpty && !symbol.isEmpty && Decimal(string: factor) != nil {
                            if let baseUnit = unit.category.units.first(where: { $0.isSystemDefined }) {
                                unit.numerator = baseUnit.numerator
                                unit.denominator = baseUnit.denominator
                            }
                            dismiss()
                        }
                    } label: {
                        Text("Save Changes")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .foregroundColor(.blue)
                    }
                    .disabled(name.isEmpty || symbol.isEmpty || Decimal(string: factor) == nil)
                }
            }
        }
        .navigationTitle(unit.isSystemDefined ? unit.name : "Edit Unit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if !unit.isSystemDefined {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    UnitDetailView(unit: Unit(Category()))
}
