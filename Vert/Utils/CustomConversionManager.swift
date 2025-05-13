import Foundation
import SwiftData

class CustomConversionManager {
    
    /// Creates a new custom formula
    /// - Parameters:
    ///   - name: The name of the formula
    ///   - symbol: The symbol for the formula
    ///   - formula: The conversion formula using 'x' as the variable
    ///   - context: The SwiftData model context
    /// - Returns: The newly created custom formula
    static func createCustomFormula(
        name: String,
        symbol: String,
        formula: String,
        context: ModelContext
    ) -> CustomFormula {
        // Create new formula
        let customFormula = CustomFormula(name: name, symbol: symbol, formula: formula)
        
        // Add to model
        context.insert(customFormula)
        
        return customFormula
    }
    
    /// Creates a unit with a linear conversion
    /// - Parameters:
    ///   - name: The name of the unit
    ///   - symbol: The symbol for the unit
    ///   - formula: The conversion formula
    ///   - context: The SwiftData model context
    /// - Returns: The newly created unit with formula
    static func createCustomUnit(
        name: String,
        symbol: String,
        formula: String,
        context: ModelContext
    ) -> Unit {
        // Create new unit
        let unit = Unit()
        unit.name = name
        unit.symbol = symbol
        unit.isSystemDefined = false
        unit.conversionFormula = formula
        
        // Add to model
        context.insert(unit)
        
        return unit
    }
    
    /// Creates a linear conversion formula
    /// - Parameters:
    ///   - name: The name of the formula
    ///   - symbol: The symbol for the formula
    ///   - scale: The scale factor (will generate formula "x * scale")
    ///   - offset: Optional offset (will generate formula "x * scale + offset")
    ///   - context: The SwiftData model context
    /// - Returns: The newly created formula
    static func createLinearFormula(
        name: String,
        symbol: String,
        scale: Decimal,
        offset: Decimal? = nil,
        context: ModelContext
    ) -> CustomFormula {
        var formula = "x * \(scale)"
        
        if let offset = offset, offset != 0 {
            if offset > 0 {
                formula += " + \(offset)"
            } else {
                formula += " - \(abs(offset))"
            }
        }
        
        return createCustomFormula(name: name, symbol: symbol, formula: formula, context: context)
    }
    
    /// Helper method for creating common temperature formulas
    /// - Parameters:
    ///   - type: The type of temperature formula to create
    ///   - context: The SwiftData model context
    /// - Returns: The newly created temperature formula
    static func createTemperatureFormula(
        type: TemperatureType,
        context: ModelContext
    ) -> CustomFormula {
        switch type {
        case .celsiusToFahrenheit:
            return createCustomFormula(
                name: "Celsius to Fahrenheit",
                symbol: "°C → °F",
                formula: "x * 9/5 + 32",
                context: context
            )
        case .fahrenheitToCelsius:
            return createCustomFormula(
                name: "Fahrenheit to Celsius",
                symbol: "°F → °C", 
                formula: "(x - 32) * 5/9",
                context: context
            )
        case .celsiusToKelvin:
            return createCustomFormula(
                name: "Celsius to Kelvin",
                symbol: "°C → K",
                formula: "x + 273.15",
                context: context
            )
        case .kelvinToCelsius:
            return createCustomFormula(
                name: "Kelvin to Celsius",
                symbol: "K → °C",
                formula: "x - 273.15",
                context: context
            )
        }
    }
    
    /// Enum representing common temperature formula types
    enum TemperatureType {
        case celsiusToFahrenheit
        case fahrenheitToCelsius
        case celsiusToKelvin
        case kelvinToCelsius
    }
} 