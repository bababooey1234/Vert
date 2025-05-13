import Foundation
import SwiftData

class CustomConversionManager {
    
    /// Creates a new custom unit with a formula-based conversion
    /// - Parameters:
    ///   - category: The category to add the unit to
    ///   - name: The name of the new unit
    ///   - symbol: The symbol for the new unit
    ///   - formula: The conversion formula using 'x' as the variable
    ///   - context: The SwiftData model context
    /// - Returns: The newly created unit
    static func createCustomUnit(
        in category: Category,
        name: String,
        symbol: String,
        formula: String,
        context: ModelContext
    ) -> Unit {
        // Create new unit
        let unit = Unit(category)
        unit.name = name
        unit.symbol = symbol
        unit.isSystemDefined = false
        unit.conversionFormula = formula
        
        // Add to model and category
        context.insert(unit)
        category.units.append(unit)
        
        return unit
    }
    
    /// Creates a linear conversion unit
    /// - Parameters:
    ///   - category: The category to add the unit to
    ///   - name: The name of the new unit
    ///   - symbol: The symbol for the new unit
    ///   - scale: The scale factor (will generate formula "x * scale")
    ///   - offset: Optional offset (will generate formula "x * scale + offset")
    ///   - context: The SwiftData model context
    /// - Returns: The newly created unit
    static func createLinearConversion(
        in category: Category,
        name: String,
        symbol: String,
        scale: Decimal,
        offset: Decimal? = nil,
        context: ModelContext
    ) -> Unit {
        var formula = "x * \(scale)"
        
        if let offset = offset, offset != 0 {
            if offset > 0 {
                formula += " + \(offset)"
            } else {
                formula += " - \(abs(offset))"
            }
        }
        
        return createCustomUnit(in: category, name: name, symbol: symbol, formula: formula, context: context)
    }
    
    /// Helper method for creating common temperature conversions
    /// - Parameters:
    ///   - category: The temperature category
    ///   - type: The type of temperature unit to create
    ///   - context: The SwiftData model context
    /// - Returns: The newly created temperature unit
    static func createTemperatureUnit(
        in category: Category,
        type: TemperatureType,
        context: ModelContext
    ) -> Unit {
        switch type {
        case .celsius:
            return createCustomUnit(
                in: category,
                name: "Celsius",
                symbol: "°C",
                formula: "x",
                context: context
            )
        case .fahrenheit:
            return createCustomUnit(
                in: category,
                name: "Fahrenheit",
                symbol: "°F", 
                formula: "x * 9/5 + 32",
                context: context
            )
        case .kelvin:
            return createCustomUnit(
                in: category,
                name: "Kelvin",
                symbol: "K",
                formula: "x + 273.15",
                context: context
            )
        }
    }
    
    /// Enum representing common temperature unit types
    enum TemperatureType {
        case celsius
        case fahrenheit
        case kelvin
    }
} 