import Foundation
import SwiftData

@Model final class CustomFormula {
    var id: UUID
    var name: String
    var symbol: String
    var formula: String
    
    init(name: String, symbol: String, formula: String) {
        id = UUID()
        self.name = name
        self.symbol = symbol
        self.formula = formula
    }
}

@Model final class Unit {
    var id: UUID
    var isSystemDefined: Bool
    var name: String
    var symbol: String
    var useMetricPrefixes: Bool
    var factor: Decimal
    var numerator: [Int]
    var denominator: [Int]
    var conversionFormula: String?
    
    init(name: String, symbol: String, useMetricPrefixes: Bool, factor: Decimal, numerator: [Int], denominator: [Int]) {
        id = UUID()
        isSystemDefined = true
        self.name = name
        self.symbol = symbol
        self.useMetricPrefixes = useMetricPrefixes
        self.factor = factor
        self.numerator = numerator
        self.denominator = denominator
        self.conversionFormula = nil
    }
    
    convenience init() {
        self.init(name: "New Unit", symbol: "unit", useMetricPrefixes: false, factor: 1, numerator: [], denominator: [])
        isSystemDefined = false
    }
}
