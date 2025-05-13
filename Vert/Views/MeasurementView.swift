import SwiftUI
import SwiftData

struct MeasurementView: View {
    @Query(sort: \Unit.name) var units: [Unit]
    @Query(sort: \CustomFormula.name) var customFormulas: [CustomFormula]
    @State private var fromUnit: Unit?
    @State private var toUnit: Unit?
    @State private var selectedFormula: CustomFormula?
    @State private var inputValue: String = ""
    @State private var result: String = ""
    @FocusState private var isInputFocused: Bool
    @State private var conversionMode: ConversionMode = .units
    
    enum ConversionMode {
        case units
        case formula
    }
    
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
                
                if conversionMode == .units, let fromUnit = fromUnit {
                    Text(fromUnit.symbol)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
            
            Picker("Conversion Mode", selection: $conversionMode) {
                Text("Units").tag(ConversionMode.units)
                Text("Formulas").tag(ConversionMode.formula)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            .onChange(of: conversionMode) { _, _ in
                result = ""
            }
            
            if conversionMode == .units {
                HStack(spacing: 20) {
                    VStack(alignment: .leading) {
                        Menu {
                            ForEach(units, id: \.id) { unit in
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
                                Text(fromUnit?.name ?? "Select Unit")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    
                    VStack(alignment: .leading) {
                        Menu {
                            ForEach(units, id: \.id) { unit in
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
                                Text(toUnit?.name ?? "Select Unit")
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
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
            } else {
                VStack(alignment: .leading) {
                    Menu {
                        ForEach(customFormulas, id: \.id) { formula in
                            Button(action: {
                                selectedFormula = formula
                                updateResult()
                            }) {
                                if selectedFormula?.id == formula.id {
                                    Label(formula.name, systemImage: "checkmark")
                                } else {
                                    Text(formula.name)
                                }
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedFormula?.name ?? "Select Formula")
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
                    
                    if let formula = selectedFormula?.formula {
                        Text("Formula: \(formula)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
            }
            
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
            if let firstUnit = units.first {
                fromUnit = firstUnit
                if units.count > 1 {
                    toUnit = units[1]
                } else {
                    toUnit = units.first
                }
            }
            
            if let firstFormula = customFormulas.first {
                selectedFormula = firstFormula
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
        switch conversionMode {
        case .units:
            updateUnitResult()
        case .formula:
            updateFormulaResult()
        }
    }
    
    private func updateUnitResult() {
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
    
    private func updateFormulaResult() {
        guard let formula = selectedFormula,
              !inputValue.isEmpty else {
            result = ""
            return
        }
        
        guard let inputDecimal = Decimal(string: inputValue) else {
            result = "Invalid number"
            return
        }
        
        do {
            let convertedValue = try FormulaEvaluator.evaluate(formula: formula.formula, x: inputDecimal)
            
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 8
            formatter.minimumFractionDigits = 0
            formatter.numberStyle = .decimal
            
            if let formattedValue = formatter.string(from: convertedValue as NSDecimalNumber) {
                result = formattedValue
            }
        } catch {
            result = "Error: \(error.localizedDescription)"
        }
    }
    
    private func convert(value: Decimal, from: Unit, to: Unit) -> Decimal {
        if from.numerator.contains(4) && to.numerator.contains(4) {
            return convertTemperature(value: value, from: from, to: to)
        }
        
        if let fromFormula = from.conversionFormula {
            do {
                return try FormulaEvaluator.evaluate(formula: fromFormula, x: value)
            } catch {
                print("Error evaluating 'from' formula: \(error.localizedDescription)")
            }
        } 
        else if let toFormula = to.conversionFormula {
            do {
                let baseValue = value * from.factor
                return try FormulaEvaluator.evaluate(formula: toFormula, x: baseValue)
            } catch {
                print("Error evaluating 'to' formula: \(error.localizedDescription)")
            }
        }
        
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
