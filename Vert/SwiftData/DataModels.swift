import Foundation
import SwiftData

@Model final class Category {
    var id: UUID
    var isSystemDefined: Bool
    var name: String
    @Relationship var units: [Unit]
    
    init(name: String) {
        id = UUID()
        isSystemDefined = true
        units = []
        self.name = name
    }
    
    convenience init() {
        self.init(name: "New Category")
        isSystemDefined = false
    }
}

@Model final class Unit {
    var id: UUID
    var isSystemDefined: Bool
    var category: Category
    var name: String
    var symbol: String
    var useMetricPrefixes: Bool
    var factor: Decimal
    var numerator: [Int]
    var denominator: [Int]
    var conversionFormula: String?
    
    init(category: Category, name: String, symbol: String, useMetricPrefixes: Bool, factor: Decimal, numerator: [Int], denominator: [Int]) {
        id = UUID()
        isSystemDefined = true
        self.category = category
        self.name = name
        self.symbol = symbol
        self.useMetricPrefixes = useMetricPrefixes
        self.factor = factor
        self.numerator = numerator
        self.denominator = denominator
        self.conversionFormula = nil
    }
    
    convenience init(_ category: Category) {
        let defaultNumerator: [Int]
        let defaultDenominator: [Int]
        
        if let baseUnit = category.units.first(where: { $0.isSystemDefined }) {
            defaultNumerator = baseUnit.numerator
            defaultDenominator = baseUnit.denominator
        } else {
            defaultNumerator = []
            defaultDenominator = []
        }
        
        self.init(category: category, name: "New Unit", symbol: "unit", useMetricPrefixes: false, factor: 1, numerator: defaultNumerator, denominator: defaultDenominator)
        isSystemDefined = false
    }
}
