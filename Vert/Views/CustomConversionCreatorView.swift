import SwiftUI
import SwiftData

struct CustomConversionCreatorView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var category: Category
    
    @State private var name: String = ""
    @State private var symbol: String = ""
    @State private var formula: String = "x"
    @State private var testInput: String = "1"
    @State private var previewResult: String = ""
    @State private var formulaIsValid: Bool = true
    @State private var errorMessage: String = ""
    @State private var selectedFormulaType: FormulaType = .custom
    
    // Common formula types
    enum FormulaType: String, CaseIterable, Identifiable {
        case custom = "Custom Formula"
        case linear = "Linear (y = ax + b)"
        case fahrenheitToCelsius = "Fahrenheit → Celsius"
        case celsiusToFahrenheit = "Celsius → Fahrenheit"
        case celsiusToKelvin = "Celsius → Kelvin"
        case kelvinToCelsius = "Kelvin → Celsius"
        
        var id: String { self.rawValue }
        
        var formula: String {
            switch self {
            case .custom:
                return ""
            case .linear:
                return "x * a + b"
            case .fahrenheitToCelsius:
                return "(x - 32) * 5/9"
            case .celsiusToFahrenheit:
                return "x * 9/5 + 32"
            case .celsiusToKelvin:
                return "x + 273.15"
            case .kelvinToCelsius:
                return "x - 273.15"
            }
        }
    }
    
    @State private var linearScaleFactor: String = "1"
    @State private var linearOffset: String = "0"
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Unit Details")) {
                    TextField("Name (e.g., Fahrenheit)", text: $name)
                        .autocapitalization(.words)
                    
                    TextField("Symbol (e.g., °F)", text: $symbol)
                }
                
                Section(header: Text("Formula Type")) {
                    Picker("Formula Type", selection: $selectedFormulaType) {
                        ForEach(FormulaType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedFormulaType) { _, newValue in
                        updateFormulaBasedOnType()
                    }
                    
                    if selectedFormulaType == .linear {
                        HStack {
                            Text("Scale Factor (a):")
                            TextField("1", text: $linearScaleFactor)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: linearScaleFactor) { _, _ in
                                    updateLinearFormula()
                                }
                        }
                        
                        HStack {
                            Text("Offset (b):")
                            TextField("0", text: $linearOffset)
                                .keyboardType(.decimalPad)
                                .multilineTextAlignment(.trailing)
                                .onChange(of: linearOffset) { _, _ in
                                    updateLinearFormula()
                                }
                        }
                    }
                }
                
                Section(header: Text("Conversion Formula")) {
                    TextField("Formula using 'x' (e.g., x * 9/5 + 32)", text: $formula)
                        .onChange(of: formula) { _, newValue in
                            validateFormula()
                        }
                        .foregroundColor(formulaIsValid ? .primary : .red)
                    
                    if !formulaIsValid {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Text("The variable 'x' represents the input value")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Section(header: Text("Test Your Formula")) {
                    HStack {
                        Text("Input:")
                        TextField("Test value", text: $testInput)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .onChange(of: testInput) { _, _ in
                                updatePreview()
                            }
                    }
                    
                    if !previewResult.isEmpty {
                        HStack {
                            Text("Result:")
                            Spacer()
                            Text(previewResult)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Button("Calculate Preview") {
                        updatePreview()
                    }
                }
                
                Section(header: Text("Examples")) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Common Formulas:")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        ExampleFormulaRow(name: "Fahrenheit to Celsius", formula: "(x - 32) * 5/9")
                        ExampleFormulaRow(name: "Celsius to Fahrenheit", formula: "x * 9/5 + 32")
                        ExampleFormulaRow(name: "Kilometers to Miles", formula: "x * 0.621371")
                        ExampleFormulaRow(name: "Miles to Kilometers", formula: "x * 1.60934")
                        ExampleFormulaRow(name: "Pounds to Kilograms", formula: "x * 0.453592")
                        ExampleFormulaRow(name: "Kilograms to Pounds", formula: "x * 2.20462")
                    }
                }
            }
            .navigationTitle("Create Custom Unit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveUnit()
                    }
                    .disabled(name.isEmpty || symbol.isEmpty || !formulaIsValid)
                }
            }
        }
        .onAppear {
            validateFormula()
        }
    }
    
    private func updateFormulaBasedOnType() {
        if selectedFormulaType != .custom && selectedFormulaType != .linear {
            formula = selectedFormulaType.formula
            validateFormula()
        } else if selectedFormulaType == .linear {
            updateLinearFormula()
        }
    }
    
    private func updateLinearFormula() {
        let scale = Decimal(string: linearScaleFactor) ?? 1
        let offset = Decimal(string: linearOffset) ?? 0
        
        if offset == 0 {
            formula = "x * \(scale)"
        } else if offset > 0 {
            formula = "x * \(scale) + \(offset)"
        } else {
            formula = "x * \(scale) - \(abs(offset))"
        }
        
        validateFormula()
    }
    
    private func validateFormula() {
        if formula.isEmpty {
            formulaIsValid = false
            errorMessage = "Formula cannot be empty"
            return
        }
        
        formulaIsValid = FormulaEvaluator.isValid(formula: formula)
        if !formulaIsValid {
            errorMessage = "Invalid formula"
        } else {
            updatePreview()
        }
    }
    
    private func updatePreview() {
        guard formulaIsValid, !testInput.isEmpty,
              let testValue = Decimal(string: testInput) else {
            previewResult = ""
            return
        }
        
        do {
            let result = try FormulaEvaluator.evaluate(formula: formula, x: testValue)
            
            // Format result
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 6
            formatter.minimumFractionDigits = 0
            formatter.numberStyle = .decimal
            
            if let formattedResult = formatter.string(from: result as NSDecimalNumber) {
                previewResult = formattedResult
            } else {
                previewResult = "\(result)"
            }
        } catch {
            previewResult = "Error: \(error.localizedDescription)"
            formulaIsValid = false
            errorMessage = error.localizedDescription
        }
    }
    
    private func saveUnit() {
        _ = CustomConversionManager.createCustomUnit(
            in: category,
            name: name,
            symbol: symbol,
            formula: formula,
            context: modelContext
        )
        dismiss()
    }
}

struct ExampleFormulaRow: View {
    let name: String
    let formula: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
            
            HStack {
                Text(formula)
                    .font(.caption.monospaced())
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button(action: {
                    UIPasteboard.general.string = formula
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Category.self, Unit.self, configurations: config)
    
    // Create a sample category
    let category = Category(name: "Test Category")
    container.mainContext.insert(category)
    
    return CustomConversionCreatorView(category: category)
        .modelContainer(container)
} 