import SwiftData

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Unit.self, CustomFormula.self)
        
        // Make sure the persistent store is empty. If it's not, return the non-empty container.
        var unitFetchDescriptor = FetchDescriptor<Unit>()
        unitFetchDescriptor.fetchLimit = 1
        guard try container.mainContext.fetch(unitFetchDescriptor).count == 0 else { return container }
        
        populateModelContainerData(container)
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Unit.self, CustomFormula.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        populateModelContainerData(container)
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

@MainActor
func populateModelContainerData(_ container: ModelContainer) {
    // Distance units
    container.mainContext.insert(Unit(name: "Meter", symbol: "m", useMetricPrefixes: true, factor: 1, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Kilometer", symbol: "km", useMetricPrefixes: false, factor: 1000, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Centimeter", symbol: "cm", useMetricPrefixes: false, factor: 0.01, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Millimeter", symbol: "mm", useMetricPrefixes: false, factor: 0.001, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Mile", symbol: "mi", useMetricPrefixes: false, factor: 1609.34, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Yard", symbol: "yd", useMetricPrefixes: false, factor: 0.9144, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Foot", symbol: "ft", useMetricPrefixes: false, factor: 0.3048, numerator: [1], denominator: []))
    container.mainContext.insert(Unit(name: "Inch", symbol: "in", useMetricPrefixes: false, factor: 0.0254, numerator: [1], denominator: []))

    // Time units
    container.mainContext.insert(Unit(name: "Second", symbol: "s", useMetricPrefixes: false, factor: 1, numerator: [2], denominator: []))
    container.mainContext.insert(Unit(name: "Minute", symbol: "min", useMetricPrefixes: false, factor: 60, numerator: [2], denominator: []))
    container.mainContext.insert(Unit(name: "Hour", symbol: "h", useMetricPrefixes: false, factor: 3600, numerator: [2], denominator: []))
    container.mainContext.insert(Unit(name: "Day", symbol: "d", useMetricPrefixes: false, factor: 86400, numerator: [2], denominator: []))
    container.mainContext.insert(Unit(name: "Week", symbol: "wk", useMetricPrefixes: false, factor: 604800, numerator: [2], denominator: []))
    container.mainContext.insert(Unit(name: "Month (avg)", symbol: "mo", useMetricPrefixes: false, factor: 2628000, numerator: [2], denominator: []))
    container.mainContext.insert(Unit(name: "Year", symbol: "yr", useMetricPrefixes: false, factor: 31536000, numerator: [2], denominator: []))

    // Mass units
    container.mainContext.insert(Unit(name: "Kilogram", symbol: "kg", useMetricPrefixes: false, factor: 1, numerator: [3], denominator: []))
    container.mainContext.insert(Unit(name: "Gram", symbol: "g", useMetricPrefixes: true, factor: 0.001, numerator: [3], denominator: []))
    container.mainContext.insert(Unit(name: "Milligram", symbol: "mg", useMetricPrefixes: false, factor: 0.000001, numerator: [3], denominator: []))
    container.mainContext.insert(Unit(name: "Metric Ton", symbol: "t", useMetricPrefixes: false, factor: 1000, numerator: [3], denominator: []))
    container.mainContext.insert(Unit(name: "Pound", symbol: "lb", useMetricPrefixes: false, factor: 0.453592, numerator: [3], denominator: []))
    container.mainContext.insert(Unit(name: "Ounce", symbol: "oz", useMetricPrefixes: false, factor: 0.0283495, numerator: [3], denominator: []))

    // Speed units
    container.mainContext.insert(Unit(name: "Meters per Second", symbol: "m/s", useMetricPrefixes: false, factor: 1, numerator: [1], denominator: [2]))
    container.mainContext.insert(Unit(name: "Kilometers per Hour", symbol: "km/h", useMetricPrefixes: false, factor: 0.277778, numerator: [1], denominator: [2]))
    container.mainContext.insert(Unit(name: "Miles per Hour", symbol: "mph", useMetricPrefixes: false, factor: 0.44704, numerator: [1], denominator: [2]))
    container.mainContext.insert(Unit(name: "Knot", symbol: "kn", useMetricPrefixes: false, factor: 0.514444, numerator: [1], denominator: [2]))

    // Volume units
    container.mainContext.insert(Unit(name: "Cubic Meter", symbol: "m³", useMetricPrefixes: true, factor: 1, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Liter", symbol: "L", useMetricPrefixes: true, factor: 0.001, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Milliliter", symbol: "mL", useMetricPrefixes: false, factor: 0.000001, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Gallon (US)", symbol: "gal", useMetricPrefixes: false, factor: 0.00378541, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Quart (US)", symbol: "qt", useMetricPrefixes: false, factor: 0.000946353, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Pint (US)", symbol: "pt", useMetricPrefixes: false, factor: 0.000473176, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Cup (US)", symbol: "cup", useMetricPrefixes: false, factor: 0.000236588, numerator: [1, 1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Fluid Ounce (US)", symbol: "fl oz", useMetricPrefixes: false, factor: 0.0000295735, numerator: [1, 1, 1], denominator: []))

    // Area units
    container.mainContext.insert(Unit(name: "Square Meter", symbol: "m²", useMetricPrefixes: true, factor: 1, numerator: [1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Square Kilometer", symbol: "km²", useMetricPrefixes: false, factor: 1000000, numerator: [1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Hectare", symbol: "ha", useMetricPrefixes: false, factor: 10000, numerator: [1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Square Mile", symbol: "mi²", useMetricPrefixes: false, factor: 2589988.11, numerator: [1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Acre", symbol: "ac", useMetricPrefixes: false, factor: 4046.86, numerator: [1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Square Foot", symbol: "ft²", useMetricPrefixes: false, factor: 0.092903, numerator: [1, 1], denominator: []))
    container.mainContext.insert(Unit(name: "Square Inch", symbol: "in²", useMetricPrefixes: false, factor: 0.00064516, numerator: [1, 1], denominator: []))

    // Temperature units
    let celsius = Unit(name: "Celsius", symbol: "°C", useMetricPrefixes: false, factor: 1, numerator: [4], denominator: [])
    let fahrenheit = Unit(name: "Fahrenheit", symbol: "°F", useMetricPrefixes: false, factor: 1, numerator: [4], denominator: [])
    let kelvin = Unit(name: "Kelvin", symbol: "K", useMetricPrefixes: false, factor: 1, numerator: [4], denominator: [])
    
    container.mainContext.insert(celsius)
    container.mainContext.insert(fahrenheit)
    container.mainContext.insert(kelvin)

    // Energy units
    container.mainContext.insert(Unit(name: "Joule", symbol: "J", useMetricPrefixes: true, factor: 1, numerator: [3, 1, 1], denominator: [2, 2]))
    container.mainContext.insert(Unit(name: "Kilojoule", symbol: "kJ", useMetricPrefixes: false, factor: 1000, numerator: [3, 1, 1], denominator: [2, 2]))
    container.mainContext.insert(Unit(name: "Calorie", symbol: "cal", useMetricPrefixes: false, factor: 4.184, numerator: [3, 1, 1], denominator: [2, 2]))
    container.mainContext.insert(Unit(name: "Kilocalorie", symbol: "kcal", useMetricPrefixes: false, factor: 4184, numerator: [3, 1, 1], denominator: [2, 2]))
    container.mainContext.insert(Unit(name: "Watt-hour", symbol: "Wh", useMetricPrefixes: true, factor: 3600, numerator: [3, 1, 1], denominator: [2, 2]))
    container.mainContext.insert(Unit(name: "Kilowatt-hour", symbol: "kWh", useMetricPrefixes: false, factor: 3600000, numerator: [3, 1, 1], denominator: [2, 2]))
    container.mainContext.insert(Unit(name: "Electronvolt", symbol: "eV", useMetricPrefixes: true, factor: 1.602176634e-19, numerator: [3, 1, 1], denominator: [2, 2]))
    
    // Pressure units
    container.mainContext.insert(Unit(name: "Pascal", symbol: "Pa", useMetricPrefixes: true, factor: 1, numerator: [3], denominator: [1, 1, 2]))
    container.mainContext.insert(Unit(name: "Kilopascal", symbol: "kPa", useMetricPrefixes: false, factor: 1000, numerator: [3], denominator: [1, 1, 2]))
    container.mainContext.insert(Unit(name: "Bar", symbol: "bar", useMetricPrefixes: false, factor: 100000, numerator: [3], denominator: [1, 1, 2]))
    container.mainContext.insert(Unit(name: "Atmosphere", symbol: "atm", useMetricPrefixes: false, factor: 101325, numerator: [3], denominator: [1, 1, 2]))
    container.mainContext.insert(Unit(name: "Millimeter of Mercury", symbol: "mmHg", useMetricPrefixes: false, factor: 133.322, numerator: [3], denominator: [1, 1, 2]))
    container.mainContext.insert(Unit(name: "Pound per Square Inch", symbol: "psi", useMetricPrefixes: false, factor: 6894.76, numerator: [3], denominator: [1, 1, 2]))

    // Add custom formula examples
    container.mainContext.insert(CustomFormula(name: "Fahrenheit to Celsius", symbol: "°F → °C", formula: "(x - 32) * 5/9"))
    container.mainContext.insert(CustomFormula(name: "Celsius to Fahrenheit", symbol: "°C → °F", formula: "x * 9/5 + 32"))
    container.mainContext.insert(CustomFormula(name: "Miles to Kilometers", symbol: "mi → km", formula: "x * 1.60934"))
    container.mainContext.insert(CustomFormula(name: "Kilometers to Miles", symbol: "km → mi", formula: "x * 0.621371"))
    container.mainContext.insert(CustomFormula(name: "Pounds to Kilograms", symbol: "lb → kg", formula: "x * 0.453592"))
    container.mainContext.insert(CustomFormula(name: "Kilograms to Pounds", symbol: "kg → lb", formula: "x * 2.20462"))
}
