import AppIntents
import SwiftData

struct ConvertIntent: AppIntent {
    static var title = LocalizedStringResource("Convert Between Units")
    static var description = IntentDescription("Converts Units in a certain Category", resultValueName: "Conversion Result")
    
    @Parameter(title: "Value")
    var value: Double
    
    @Parameter(title: "Formula")
    var formula: FormulaEntity
    
    static var parameterSummary: some ParameterSummary {
        Summary("Convert \(\.$value) using \(\.$formula)")
    }
    
    @MainActor func perform() async throws -> some IntentResult & ReturnsValue<Double> {
        let result = try FormulaEvaluator.evaluate(formula: formula.formula, x: Decimal(value))
        return .result(value: Double(truncating: NSDecimalNumber(decimal: result)))
    }
}
