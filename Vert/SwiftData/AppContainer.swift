import SwiftData

@MainActor
let appContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: Unit.self, CustomFormula.self)
        
        // Clear any existing data
        clearAllData(context: container.mainContext)
        
        // Seed fresh data 
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
    
    // Length conversions
    container.mainContext.insert(CustomFormula(name: "Inches to Centimeters", symbol: "in → cm", formula: "x * 2.54"))
    container.mainContext.insert(CustomFormula(name: "Centimeters to Inches", symbol: "cm → in", formula: "x * 0.393701"))
    container.mainContext.insert(CustomFormula(name: "Feet to Meters", symbol: "ft → m", formula: "x * 0.3048"))
    container.mainContext.insert(CustomFormula(name: "Meters to Feet", symbol: "m → ft", formula: "x * 3.28084"))
    container.mainContext.insert(CustomFormula(name: "Yards to Meters", symbol: "yd → m", formula: "x * 0.9144"))
    container.mainContext.insert(CustomFormula(name: "Meters to Yards", symbol: "m → yd", formula: "x * 1.09361"))
    
    // Area conversions
    container.mainContext.insert(CustomFormula(name: "Square Feet to Square Meters", symbol: "ft² → m²", formula: "x * 0.092903"))
    container.mainContext.insert(CustomFormula(name: "Square Meters to Square Feet", symbol: "m² → ft²", formula: "x * 10.7639"))
    container.mainContext.insert(CustomFormula(name: "Acres to Hectares", symbol: "ac → ha", formula: "x * 0.404686"))
    container.mainContext.insert(CustomFormula(name: "Hectares to Acres", symbol: "ha → ac", formula: "x * 2.47105"))
    
    // Volume conversions
    container.mainContext.insert(CustomFormula(name: "Gallons to Liters", symbol: "gal → L", formula: "x * 3.78541"))
    container.mainContext.insert(CustomFormula(name: "Liters to Gallons", symbol: "L → gal", formula: "x * 0.264172"))
    container.mainContext.insert(CustomFormula(name: "Fluid Ounces to Milliliters", symbol: "fl oz → mL", formula: "x * 29.5735"))
    container.mainContext.insert(CustomFormula(name: "Milliliters to Fluid Ounces", symbol: "mL → fl oz", formula: "x * 0.033814"))
    container.mainContext.insert(CustomFormula(name: "Cubic Feet to Cubic Meters", symbol: "ft³ → m³", formula: "x * 0.0283168"))
    container.mainContext.insert(CustomFormula(name: "Cubic Meters to Cubic Feet", symbol: "m³ → ft³", formula: "x * 35.3147"))
    
    // Speed conversions
    container.mainContext.insert(CustomFormula(name: "MPH to KPH", symbol: "mph → km/h", formula: "x * 1.60934"))
    container.mainContext.insert(CustomFormula(name: "KPH to MPH", symbol: "km/h → mph", formula: "x * 0.621371"))
    container.mainContext.insert(CustomFormula(name: "Knots to MPH", symbol: "kn → mph", formula: "x * 1.15078"))
    container.mainContext.insert(CustomFormula(name: "MPH to Knots", symbol: "mph → kn", formula: "x * 0.868976"))
    container.mainContext.insert(CustomFormula(name: "Meters per Second to MPH", symbol: "m/s → mph", formula: "x * 2.23694"))
    container.mainContext.insert(CustomFormula(name: "MPH to Meters per Second", symbol: "mph → m/s", formula: "x * 0.44704"))
    
    // Temperature conversions (additional)
    container.mainContext.insert(CustomFormula(name: "Celsius to Kelvin", symbol: "°C → K", formula: "x + 273.15"))
    container.mainContext.insert(CustomFormula(name: "Kelvin to Celsius", symbol: "K → °C", formula: "x - 273.15"))
    container.mainContext.insert(CustomFormula(name: "Fahrenheit to Kelvin", symbol: "°F → K", formula: "(x - 32) * 5/9 + 273.15"))
    container.mainContext.insert(CustomFormula(name: "Kelvin to Fahrenheit", symbol: "K → °F", formula: "(x - 273.15) * 9/5 + 32"))
    
    // Pressure conversions
    container.mainContext.insert(CustomFormula(name: "PSI to Bar", symbol: "psi → bar", formula: "x * 0.0689476"))
    container.mainContext.insert(CustomFormula(name: "Bar to PSI", symbol: "bar → psi", formula: "x * 14.5038"))
    container.mainContext.insert(CustomFormula(name: "Atmospheres to PSI", symbol: "atm → psi", formula: "x * 14.6959"))
    container.mainContext.insert(CustomFormula(name: "PSI to Atmospheres", symbol: "psi → atm", formula: "x * 0.068046"))
    container.mainContext.insert(CustomFormula(name: "Pascals to Millimeters of Mercury", symbol: "Pa → mmHg", formula: "x * 0.00750062"))
    container.mainContext.insert(CustomFormula(name: "Millimeters of Mercury to Pascals", symbol: "mmHg → Pa", formula: "x * 133.322"))
    
    // Energy conversions
    container.mainContext.insert(CustomFormula(name: "Joules to Calories", symbol: "J → cal", formula: "x * 0.239006"))
    container.mainContext.insert(CustomFormula(name: "Calories to Joules", symbol: "cal → J", formula: "x * 4.184"))
    container.mainContext.insert(CustomFormula(name: "Kilowatt-hours to Megajoules", symbol: "kWh → MJ", formula: "x * 3.6"))
    container.mainContext.insert(CustomFormula(name: "Megajoules to Kilowatt-hours", symbol: "MJ → kWh", formula: "x * 0.277778"))
    container.mainContext.insert(CustomFormula(name: "BTU to Joules", symbol: "BTU → J", formula: "x * 1055.06"))
    container.mainContext.insert(CustomFormula(name: "Joules to BTU", symbol: "J → BTU", formula: "x * 0.000947817"))
    
    // Time conversions
    container.mainContext.insert(CustomFormula(name: "Days to Hours", symbol: "d → h", formula: "x * 24"))
    container.mainContext.insert(CustomFormula(name: "Hours to Days", symbol: "h → d", formula: "x / 24"))
    container.mainContext.insert(CustomFormula(name: "Weeks to Days", symbol: "wk → d", formula: "x * 7"))
    container.mainContext.insert(CustomFormula(name: "Days to Weeks", symbol: "d → wk", formula: "x / 7"))
    container.mainContext.insert(CustomFormula(name: "Years to Days", symbol: "yr → d", formula: "x * 365.25"))
    container.mainContext.insert(CustomFormula(name: "Days to Years", symbol: "d → yr", formula: "x / 365.25"))
    
    // Useful math formulas
    container.mainContext.insert(CustomFormula(name: "Square Root", symbol: "√x", formula: "sqrt(x)"))
    container.mainContext.insert(CustomFormula(name: "Cube Root", symbol: "∛x", formula: "cbrt(x)"))
    container.mainContext.insert(CustomFormula(name: "Square", symbol: "x²", formula: "x * x"))
    container.mainContext.insert(CustomFormula(name: "Cube", symbol: "x³", formula: "x * x * x"))
    container.mainContext.insert(CustomFormula(name: "Reciprocal", symbol: "1/x", formula: "1 / x"))
    container.mainContext.insert(CustomFormula(name: "Logarithm (Base 10)", symbol: "log₁₀(x)", formula: "log10(x)"))
    container.mainContext.insert(CustomFormula(name: "Natural Logarithm", symbol: "ln(x)", formula: "log(x)"))
    
    // Data unit conversions
    container.mainContext.insert(CustomFormula(name: "Bytes to Kilobytes", symbol: "B → KB", formula: "x / 1024"))
    container.mainContext.insert(CustomFormula(name: "Kilobytes to Megabytes", symbol: "KB → MB", formula: "x / 1024"))
    container.mainContext.insert(CustomFormula(name: "Megabytes to Gigabytes", symbol: "MB → GB", formula: "x / 1024"))
    container.mainContext.insert(CustomFormula(name: "Gigabytes to Terabytes", symbol: "GB → TB", formula: "x / 1024"))
    container.mainContext.insert(CustomFormula(name: "Bits to Bytes", symbol: "b → B", formula: "x / 8"))
    container.mainContext.insert(CustomFormula(name: "Bytes to Bits", symbol: "B → b", formula: "x * 8"))
    container.mainContext.insert(CustomFormula(name: "Megabits to Megabytes", symbol: "Mb → MB", formula: "x / 8"))
    container.mainContext.insert(CustomFormula(name: "Megabytes to Megabits", symbol: "MB → Mb", formula: "x * 8"))
    
    // Financial conversions (placeholders - exchange rates would need to be updated)
    container.mainContext.insert(CustomFormula(name: "USD to EUR", symbol: "USD → EUR", formula: "x * 0.93"))
    container.mainContext.insert(CustomFormula(name: "EUR to USD", symbol: "EUR → USD", formula: "x * 1.07"))
    container.mainContext.insert(CustomFormula(name: "USD to GBP", symbol: "USD → GBP", formula: "x * 0.79"))
    container.mainContext.insert(CustomFormula(name: "GBP to USD", symbol: "GBP → USD", formula: "x * 1.27"))
    container.mainContext.insert(CustomFormula(name: "USD to JPY", symbol: "USD → JPY", formula: "x * 154.50"))
    container.mainContext.insert(CustomFormula(name: "JPY to USD", symbol: "JPY → USD", formula: "x * 0.0065"))
    
    // Power conversions
    container.mainContext.insert(CustomFormula(name: "Watts to Kilowatts", symbol: "W → kW", formula: "x / 1000"))
    container.mainContext.insert(CustomFormula(name: "Kilowatts to Watts", symbol: "kW → W", formula: "x * 1000"))
    container.mainContext.insert(CustomFormula(name: "Horsepower to Watts", symbol: "hp → W", formula: "x * 745.7"))
    container.mainContext.insert(CustomFormula(name: "Watts to Horsepower", symbol: "W → hp", formula: "x / 745.7"))
    
    // Angle conversions
    container.mainContext.insert(CustomFormula(name: "Degrees to Radians", symbol: "° → rad", formula: "x * 0.0174533"))
    container.mainContext.insert(CustomFormula(name: "Radians to Degrees", symbol: "rad → °", formula: "x * 57.2958"))
    
    // Fuel efficiency conversions
    container.mainContext.insert(CustomFormula(name: "MPG to L/100km", symbol: "mpg → L/100km", formula: "235.215 / x"))
    container.mainContext.insert(CustomFormula(name: "L/100km to MPG", symbol: "L/100km → mpg", formula: "235.215 / x"))
    
    // Cooking conversions
    container.mainContext.insert(CustomFormula(name: "Tablespoons to Teaspoons", symbol: "tbsp → tsp", formula: "x * 3"))
    container.mainContext.insert(CustomFormula(name: "Cups to Tablespoons", symbol: "cup → tbsp", formula: "x * 16"))
    container.mainContext.insert(CustomFormula(name: "Cups to Milliliters", symbol: "cup → mL", formula: "x * 236.588"))
    container.mainContext.insert(CustomFormula(name: "Pounds to Cups (Flour)", symbol: "lb → cup (flour)", formula: "x * 3.6"))
    container.mainContext.insert(CustomFormula(name: "Pounds to Cups (Sugar)", symbol: "lb → cup (sugar)", formula: "x * 2.25"))
    
    // Photography/optics
    container.mainContext.insert(CustomFormula(name: "f-stop to T-stop", symbol: "f → T", formula: "x / sqrt(0.9)"))
    container.mainContext.insert(CustomFormula(name: "Aperture to f-number", symbol: "A → f", formula: "1 / (2 * x)"))
    container.mainContext.insert(CustomFormula(name: "Focal Length to Angle of View", symbol: "FL → AOV", formula: "2 * atan(36 / (2 * x))"))
    
    // Scientific calculations
    container.mainContext.insert(CustomFormula(name: "Temperature to Energy", symbol: "T → E", formula: "x * 1.380649e-23"))
    container.mainContext.insert(CustomFormula(name: "Mass to Energy (E=mc²)", symbol: "m → E", formula: "x * 89875517873681764"))
    container.mainContext.insert(CustomFormula(name: "Frequency to Wavelength", symbol: "f → λ", formula: "299792458 / x"))
    container.mainContext.insert(CustomFormula(name: "pH to H⁺ Concentration", symbol: "pH → [H⁺]", formula: "pow(10, -x)"))
    container.mainContext.insert(CustomFormula(name: "H⁺ Concentration to pH", symbol: "[H⁺] → pH", formula: "-log10(x)"))
    
    // Fitness/health
    container.mainContext.insert(CustomFormula(name: "BMI for 1.75m height", symbol: "kg → BMI", formula: "x / 3.0625"))
    container.mainContext.insert(CustomFormula(name: "Calories to Kilojoules", symbol: "cal → kJ", formula: "x * 0.004184"))
    container.mainContext.insert(CustomFormula(name: "Ideal Weight (Men)", symbol: "cm → kg", formula: "(x - 100) * 0.9"))
    
    // Financial/economics
    container.mainContext.insert(CustomFormula(name: "5% Interest (1 year)", symbol: "P → A", formula: "x * 1.05"))
    container.mainContext.insert(CustomFormula(name: "Compound Interest (5%, 10yr)", symbol: "P → A", formula: "x * pow(1.05, 10)"))
    container.mainContext.insert(CustomFormula(name: "Present Value (5%, 10yr)", symbol: "FV → PV", formula: "x / pow(1.05, 10)"))
    
    // Probability/statistics
    container.mainContext.insert(CustomFormula(name: "Normal PDF", symbol: "z → PDF", formula: "exp(-0.5 * x * x) / sqrt(2 * 3.14159265359)"))
    container.mainContext.insert(CustomFormula(name: "Poisson PMF (k=2)", symbol: "λ → PMF", formula: "exp(-x) * pow(x, 2) / 2"))
    
    // Physics and engineering
    container.mainContext.insert(CustomFormula(name: "Kinetic Energy", symbol: "v → KE (m=1)", formula: "0.5 * pow(x, 2)"))
    container.mainContext.insert(CustomFormula(name: "Gravitational PE", symbol: "h → PE (m=1)", formula: "9.81 * x"))
    container.mainContext.insert(CustomFormula(name: "Doppler Effect", symbol: "v → f' (f=1000)", formula: "1000 * (343 / (343 - x))"))
    container.mainContext.insert(CustomFormula(name: "RC Circuit Charging", symbol: "t → V (τ=1)", formula: "1 - exp(-x)"))
    
    // Geometry 
    container.mainContext.insert(CustomFormula(name: "Circle Area", symbol: "r → A", formula: "PI * pow(x, 2)"))
    container.mainContext.insert(CustomFormula(name: "Sphere Volume", symbol: "r → V", formula: "(4/3) * PI * pow(x, 3)"))
    container.mainContext.insert(CustomFormula(name: "Regular Polygon Area", symbol: "s → A (n=6)", formula: "(6 * pow(x, 2)) / (4 * tan(PI/6))"))
    
    // Trigonometry
    container.mainContext.insert(CustomFormula(name: "Sine Wave", symbol: "θ → sin", formula: "sin(x)"))
    container.mainContext.insert(CustomFormula(name: "Cosine Wave", symbol: "θ → cos", formula: "cos(x)"))
    container.mainContext.insert(CustomFormula(name: "Tangent Wave", symbol: "θ → tan", formula: "tan(x)"))
    
    // Electronics
    container.mainContext.insert(CustomFormula(name: "Ohm's Law (Voltage)", symbol: "I → V (R=10)", formula: "x * 10"))
    container.mainContext.insert(CustomFormula(name: "Ohm's Law (Current)", symbol: "V → I (R=10)", formula: "x / 10"))
    container.mainContext.insert(CustomFormula(name: "Power (DC Circuit)", symbol: "V → P (R=10)", formula: "pow(x, 2) / 10"))
    
    // Optics
    container.mainContext.insert(CustomFormula(name: "Thin Lens", symbol: "di → f (do=100)", formula: "(100 * x) / (100 + x)"))
    container.mainContext.insert(CustomFormula(name: "Magnification", symbol: "di → M (do=100)", formula: "x / 100"))
    
    // Chemistry
    container.mainContext.insert(CustomFormula(name: "Ideal Gas Law", symbol: "T → P (V=1, n=1)", formula: "0.0821 * x"))
    container.mainContext.insert(CustomFormula(name: "Arrhenius Equation", symbol: "T → k (Ea=50)", formula: "1e10 * exp(-50 / (0.008314 * x))"))
    
    // Finance additional
    container.mainContext.insert(CustomFormula(name: "Inflation Adjustment", symbol: "$ → $ (3% for 5yr)", formula: "x * pow(1.03, 5)"))
    container.mainContext.insert(CustomFormula(name: "Loan Payment", symbol: "P → Payment (5%, 30yr)", formula: "x * (0.05/12) / (1 - pow(1 + 0.05/12, -360))"))
}

@MainActor
func clearAllData(context: ModelContext) {
    do {
        // Delete all existing formulas
        try context.delete(model: CustomFormula.self)
        
        // Delete all existing units
        try context.delete(model: Unit.self)
    } catch {
        print("Error clearing data: \(error)")
    }
}

@MainActor
func directSeedData(context: ModelContext) {
    // Add basic formulas directly to the context
    context.insert(CustomFormula(name: "Fahrenheit to Celsius", symbol: "°F → °C", formula: "(x - 32) * 5/9"))
    context.insert(CustomFormula(name: "Celsius to Fahrenheit", symbol: "°C → °F", formula: "x * 9/5 + 32"))
    context.insert(CustomFormula(name: "Miles to Kilometers", symbol: "mi → km", formula: "x * 1.60934"))
    context.insert(CustomFormula(name: "Kilometers to Miles", symbol: "km → mi", formula: "x * 0.621371"))
    context.insert(CustomFormula(name: "Pounds to Kilograms", symbol: "lb → kg", formula: "x * 0.453592"))
    context.insert(CustomFormula(name: "Kilograms to Pounds", symbol: "kg → lb", formula: "x * 2.20462"))
    
    // Length conversions
    context.insert(CustomFormula(name: "Inches to Centimeters", symbol: "in → cm", formula: "x * 2.54"))
    context.insert(CustomFormula(name: "Centimeters to Inches", symbol: "cm → in", formula: "x * 0.393701"))
    context.insert(CustomFormula(name: "Feet to Meters", symbol: "ft → m", formula: "x * 0.3048"))
    context.insert(CustomFormula(name: "Meters to Feet", symbol: "m → ft", formula: "x * 3.28084"))
    
    // Temperature conversions
    context.insert(CustomFormula(name: "Celsius to Kelvin", symbol: "°C → K", formula: "x + 273.15"))
    context.insert(CustomFormula(name: "Kelvin to Celsius", symbol: "K → °C", formula: "x - 273.15"))
    
    // Math functions
    context.insert(CustomFormula(name: "Square Root", symbol: "√x", formula: "sqrt(x)"))
    context.insert(CustomFormula(name: "Square", symbol: "x²", formula: "x * x"))
    context.insert(CustomFormula(name: "Reciprocal", symbol: "1/x", formula: "1 / x"))
}

extension ModelContext {
    func delete<T: PersistentModel>(model: T.Type) throws {
        let descriptor = FetchDescriptor<T>()
        let items = try fetch(descriptor)
        for item in items {
            delete(item)
        }
    }
}
