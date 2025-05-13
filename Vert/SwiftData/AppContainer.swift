import SwiftData

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Category.self)
        
        // Make sure the persistent store is empty. If it's not, return the non-empty container.
        var categoryFetchDescriptor = FetchDescriptor<Category>()
        categoryFetchDescriptor.fetchLimit = 1
        guard try container.mainContext.fetch(categoryFetchDescriptor).count == 0 else { return container }
        
        populateModelContainerData(container)
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Category.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        populateModelContainerData(container)
        return container
    } catch {
        fatalError("Failed to create container")
    }
}()

@MainActor
func populateModelContainerData(_ container: ModelContainer) {
    // Distance category
    let distance = Category(name: "Distance")
    distance.units.append(Unit(category: distance, name: "Meter", symbol: "m", useMetricPrefixes: true, factor: 1, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Kilometer", symbol: "km", useMetricPrefixes: false, factor: 1000, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Centimeter", symbol: "cm", useMetricPrefixes: false, factor: 0.01, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Millimeter", symbol: "mm", useMetricPrefixes: false, factor: 0.001, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Mile", symbol: "mi", useMetricPrefixes: false, factor: 1609.34, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Yard", symbol: "yd", useMetricPrefixes: false, factor: 0.9144, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Foot", symbol: "ft", useMetricPrefixes: false, factor: 0.3048, numerator: [1], denominator: []))
    distance.units.append(Unit(category: distance, name: "Inch", symbol: "in", useMetricPrefixes: false, factor: 0.0254, numerator: [1], denominator: []))

    // Time category
    let time = Category(name: "Time")
    time.units.append(Unit(category: time, name: "Second", symbol: "s", useMetricPrefixes: false, factor: 1, numerator: [2], denominator: []))
    time.units.append(Unit(category: time, name: "Minute", symbol: "min", useMetricPrefixes: false, factor: 60, numerator: [2], denominator: []))
    time.units.append(Unit(category: time, name: "Hour", symbol: "h", useMetricPrefixes: false, factor: 3600, numerator: [2], denominator: []))
    time.units.append(Unit(category: time, name: "Day", symbol: "d", useMetricPrefixes: false, factor: 86400, numerator: [2], denominator: []))
    time.units.append(Unit(category: time, name: "Week", symbol: "wk", useMetricPrefixes: false, factor: 604800, numerator: [2], denominator: []))
    time.units.append(Unit(category: time, name: "Month (avg)", symbol: "mo", useMetricPrefixes: false, factor: 2628000, numerator: [2], denominator: []))
    time.units.append(Unit(category: time, name: "Year", symbol: "yr", useMetricPrefixes: false, factor: 31536000, numerator: [2], denominator: []))

    // Mass category
    let mass = Category(name: "Mass")
    mass.units.append(Unit(category: mass, name: "Kilogram", symbol: "kg", useMetricPrefixes: false, factor: 1, numerator: [3], denominator: []))
    mass.units.append(Unit(category: mass, name: "Gram", symbol: "g", useMetricPrefixes: true, factor: 0.001, numerator: [3], denominator: []))
    mass.units.append(Unit(category: mass, name: "Milligram", symbol: "mg", useMetricPrefixes: false, factor: 0.000001, numerator: [3], denominator: []))
    mass.units.append(Unit(category: mass, name: "Metric Ton", symbol: "t", useMetricPrefixes: false, factor: 1000, numerator: [3], denominator: []))
    mass.units.append(Unit(category: mass, name: "Pound", symbol: "lb", useMetricPrefixes: false, factor: 0.453592, numerator: [3], denominator: []))
    mass.units.append(Unit(category: mass, name: "Ounce", symbol: "oz", useMetricPrefixes: false, factor: 0.0283495, numerator: [3], denominator: []))

    // Speed category
    let speed = Category(name: "Speed")
    speed.units.append(Unit(category: speed, name: "Meters per Second", symbol: "m/s", useMetricPrefixes: false, factor: 1, numerator: [1], denominator: [2]))
    speed.units.append(Unit(category: speed, name: "Kilometers per Hour", symbol: "km/h", useMetricPrefixes: false, factor: 0.277778, numerator: [1], denominator: [2]))
    speed.units.append(Unit(category: speed, name: "Miles per Hour", symbol: "mph", useMetricPrefixes: false, factor: 0.44704, numerator: [1], denominator: [2]))
    speed.units.append(Unit(category: speed, name: "Knot", symbol: "kn", useMetricPrefixes: false, factor: 0.514444, numerator: [1], denominator: [2]))

    // Volume category
    let volume = Category(name: "Volume")
    volume.units.append(Unit(category: volume, name: "Cubic Meter", symbol: "m³", useMetricPrefixes: true, factor: 1, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Liter", symbol: "L", useMetricPrefixes: true, factor: 0.001, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Milliliter", symbol: "mL", useMetricPrefixes: false, factor: 0.000001, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Gallon (US)", symbol: "gal", useMetricPrefixes: false, factor: 0.00378541, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Quart (US)", symbol: "qt", useMetricPrefixes: false, factor: 0.000946353, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Pint (US)", symbol: "pt", useMetricPrefixes: false, factor: 0.000473176, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Cup (US)", symbol: "cup", useMetricPrefixes: false, factor: 0.000236588, numerator: [1, 1, 1], denominator: []))
    volume.units.append(Unit(category: volume, name: "Fluid Ounce (US)", symbol: "fl oz", useMetricPrefixes: false, factor: 0.0000295735, numerator: [1, 1, 1], denominator: []))

    // Area category
    let area = Category(name: "Area")
    area.units.append(Unit(category: area, name: "Square Meter", symbol: "m²", useMetricPrefixes: true, factor: 1, numerator: [1, 1], denominator: []))
    area.units.append(Unit(category: area, name: "Square Kilometer", symbol: "km²", useMetricPrefixes: false, factor: 1000000, numerator: [1, 1], denominator: []))
    area.units.append(Unit(category: area, name: "Hectare", symbol: "ha", useMetricPrefixes: false, factor: 10000, numerator: [1, 1], denominator: []))
    area.units.append(Unit(category: area, name: "Square Mile", symbol: "mi²", useMetricPrefixes: false, factor: 2589988.11, numerator: [1, 1], denominator: []))
    area.units.append(Unit(category: area, name: "Acre", symbol: "ac", useMetricPrefixes: false, factor: 4046.86, numerator: [1, 1], denominator: []))
    area.units.append(Unit(category: area, name: "Square Foot", symbol: "ft²", useMetricPrefixes: false, factor: 0.092903, numerator: [1, 1], denominator: []))
    area.units.append(Unit(category: area, name: "Square Inch", symbol: "in²", useMetricPrefixes: false, factor: 0.00064516, numerator: [1, 1], denominator: []))

    // Temperature category (special conversion rules)
    let temperature = Category(name: "Temperature")
    temperature.units.append(Unit(category: temperature, name: "Celsius", symbol: "°C", useMetricPrefixes: false, factor: 1, numerator: [4], denominator: []))
    temperature.units.append(Unit(category: temperature, name: "Fahrenheit", symbol: "°F", useMetricPrefixes: false, factor: 1, numerator: [4], denominator: []))
    temperature.units.append(Unit(category: temperature, name: "Kelvin", symbol: "K", useMetricPrefixes: false, factor: 1, numerator: [4], denominator: []))

    // Energy category
    let energy = Category(name: "Energy")
    energy.units.append(Unit(category: energy, name: "Joule", symbol: "J", useMetricPrefixes: true, factor: 1, numerator: [3, 1, 1], denominator: [2, 2]))
    energy.units.append(Unit(category: energy, name: "Kilojoule", symbol: "kJ", useMetricPrefixes: false, factor: 1000, numerator: [3, 1, 1], denominator: [2, 2]))
    energy.units.append(Unit(category: energy, name: "Calorie", symbol: "cal", useMetricPrefixes: false, factor: 4.184, numerator: [3, 1, 1], denominator: [2, 2]))
    energy.units.append(Unit(category: energy, name: "Kilocalorie", symbol: "kcal", useMetricPrefixes: false, factor: 4184, numerator: [3, 1, 1], denominator: [2, 2]))
    energy.units.append(Unit(category: energy, name: "Watt-hour", symbol: "Wh", useMetricPrefixes: true, factor: 3600, numerator: [3, 1, 1], denominator: [2, 2]))
    energy.units.append(Unit(category: energy, name: "Kilowatt-hour", symbol: "kWh", useMetricPrefixes: false, factor: 3600000, numerator: [3, 1, 1], denominator: [2, 2]))
    energy.units.append(Unit(category: energy, name: "Electronvolt", symbol: "eV", useMetricPrefixes: true, factor: 1.602176634e-19, numerator: [3, 1, 1], denominator: [2, 2]))
    
    // Pressure category
    let pressure = Category(name: "Pressure")
    pressure.units.append(Unit(category: pressure, name: "Pascal", symbol: "Pa", useMetricPrefixes: true, factor: 1, numerator: [3], denominator: [1, 1, 2]))
    pressure.units.append(Unit(category: pressure, name: "Kilopascal", symbol: "kPa", useMetricPrefixes: false, factor: 1000, numerator: [3], denominator: [1, 1, 2]))
    pressure.units.append(Unit(category: pressure, name: "Bar", symbol: "bar", useMetricPrefixes: false, factor: 100000, numerator: [3], denominator: [1, 1, 2]))
    pressure.units.append(Unit(category: pressure, name: "Atmosphere", symbol: "atm", useMetricPrefixes: false, factor: 101325, numerator: [3], denominator: [1, 1, 2]))
    pressure.units.append(Unit(category: pressure, name: "Millimeter of Mercury", symbol: "mmHg", useMetricPrefixes: false, factor: 133.322, numerator: [3], denominator: [1, 1, 2]))
    pressure.units.append(Unit(category: pressure, name: "Pound per Square Inch", symbol: "psi", useMetricPrefixes: false, factor: 6894.76, numerator: [3], denominator: [1, 1, 2]))

    let categories = [
        distance,
        time,
        mass,
        speed,
        volume,
        area,
        temperature,
        energy,
        pressure
    ]
    
    for category in categories {
        container.mainContext.insert(category)
    }
}
