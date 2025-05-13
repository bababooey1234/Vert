import SwiftUI
import SwiftData

struct MeasurementView: View {
    @Query var categories: [Category]
    @State private var selectedCategory: Category?
    @State private var fromUnit: Unit?
    @State private var toUnit: Unit?
    @State private var inputValue: String = ""
    @State private var result: String = ""
    @FocusState private var isInputFocused: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                TextField("Enter value", text: $inputValue)
                    .keyboardType(.decimalPad)
                    .focused($isInputFocused)
                    .onChange(of: inputValue) { _, _ in
                        updateResult()
                    }
                    .multilineTextAlignment(.trailing)
                    .frame(minWidth: 0, maxWidth: .infinity)
                
                if let fromUnit = fromUnit {
                    Text(fromUnit.symbol)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            VStack(alignment: .leading) {
                Text("Category")
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                Menu {
                    ForEach(categories, id: \.id) { category in
                        Button(action: {
                            selectedCategory = category
                            if category.units.count > 0 {
                                fromUnit = category.units.first
                                if category.units.count > 1 {
                                    toUnit = category.units[1]
                                } else {
                                    toUnit = category.units.first
                                }
                                updateResult()
                            }
                        }) {
                            if selectedCategory?.id == category.id {
                                Label(category.name, systemImage: "checkmark")
                            } else {
                                Text(category.name)
                            }
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedCategory?.name ?? "Select Category")
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.down")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)
                }
            }
            
            HStack(spacing: 20) {
                VStack(alignment: .leading) {
                    Text("From:")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    if let selectedCategory = selectedCategory {
                        Menu {
                            ForEach(selectedCategory.units, id: \.id) { unit in
                                Button(action: {
                                    fromUnit = unit
                                    updateResult()
                                }) {
                                    if fromUnit?.id == unit.id {
                                        Label("\(unit.name) (\(unit.symbol))", systemImage: "checkmark")
                                    } else {
                                        Text("\(unit.name) (\(unit.symbol))")
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(fromUnit?.name ?? "Select")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    } else {
                        Text("Select a category first")
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
                
                VStack(alignment: .leading) {
                    Text("To:")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    if let selectedCategory = selectedCategory {
                        Menu {
                            ForEach(selectedCategory.units, id: \.id) { unit in
                                Button(action: {
                                    toUnit = unit
                                    updateResult()
                                }) {
                                    if toUnit?.id == unit.id {
                                        Label("\(unit.name) (\(unit.symbol))", systemImage: "checkmark")
                                    } else {
                                        Text("\(unit.name) (\(unit.symbol))")
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(toUnit?.name ?? "Select")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    } else {
                        Text("Select a category first")
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(minWidth: 0, maxWidth: .infinity)
            }
            .padding(.horizontal)
            
            Button(action: swapUnits) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Text("Swap Units")
                }
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.1))
                .foregroundColor(.blue)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            .disabled(fromUnit == nil || toUnit == nil)
            
            if !result.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Result")
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Text(result)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            }
            
            Spacer()
        }
        .padding(.top)
        .navigationTitle("Converter")
        .onAppear {
            if let firstCategory = categories.first {
                selectedCategory = firstCategory
                fromUnit = firstCategory.units.first
                if firstCategory.units.count > 1 {
                    toUnit = firstCategory.units[1]
                } else {
                    toUnit = firstCategory.units.first
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isInputFocused = false
                }
            }
        }
    }
    
    private func swapUnits() {
        let temp = fromUnit
        fromUnit = toUnit
        toUnit = temp
        updateResult()
    }
    
    private func updateResult() {
        guard let fromUnit = fromUnit,
              let toUnit = toUnit,
              !inputValue.isEmpty else {
            result = ""
            return
        }
        
        guard let inputDecimal = Decimal(string: inputValue) else {
            result = "Invalid number"
            return
        }
        
        let convertedValue = convert(value: inputDecimal, from: fromUnit, to: toUnit)
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        formatter.numberStyle = .decimal
        
        if let formattedValue = formatter.string(from: convertedValue as NSDecimalNumber) {
            result = "\(formattedValue) \(toUnit.symbol)"
        }
    }
    
    private func convert(value: Decimal, from: Unit, to: Unit) -> Decimal {
        if from.category.name == "Temperature" {
            return convertTemperature(value: value, from: from, to: to)
        }
        
        // Check if the "from" unit has a custom formula
        if let fromFormula = from.conversionFormula {
            do {
                // Convert directly from the input to the target unit using formula
                let baseValue = try FormulaEvaluator.evaluate(formula: fromFormula, x: value)
                return baseValue / to.factor
            } catch {
                print("Error evaluating 'from' formula: \(error.localizedDescription)")
                // Fall back to standard conversion
            }
        } 
        // Check if the "to" unit has a custom formula
        else if let toFormula = to.conversionFormula {
            do {
                // First convert to base unit
                let baseValue = value * from.factor
                // Then use formula to convert from base unit to target
                let xValue = baseValue
                return try FormulaEvaluator.evaluate(formula: toFormula, x: xValue)
            } catch {
                print("Error evaluating 'to' formula: \(error.localizedDescription)")
                // Fall back to standard conversion
            }
        }
        
        // Standard conversion using factors
        let valueInBaseUnit = value * from.factor
        let valueInTargetUnit = valueInBaseUnit / to.factor
        return valueInTargetUnit
    }
    
    private func convertTemperature(value: Decimal, from: Unit, to: Unit) -> Decimal {
        let fromSymbol = from.symbol
        let toSymbol = to.symbol
        
        var celsius: Decimal = 0
        
        switch fromSymbol {
        case "°C":
            celsius = value
        case "°F":
            celsius = (value - 32) * 5 / 9
        case "K":
            celsius = value - 273.15
        default:
            return 0
        }
        
        switch toSymbol {
        case "°C":
            return celsius
        case "°F":
            return celsius * 9 / 5 + 32
        case "K":
            return celsius + 273.15
        default:
            return 0
        }
    }
}

#Preview {
    MeasurementView()
        .modelContainer(previewContainer)
}
