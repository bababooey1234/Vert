import Foundation
import JavaScriptCore

class FormulaEvaluator {
    
    enum FormulaError: Error, LocalizedError {
        case invalidFormula(String)
        case evaluationError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidFormula(let details):
                return "Invalid formula: \(details)"
            case .evaluationError(let details):
                return "Error evaluating formula: \(details)"
            }
        }
    }
    
    /// Evaluates a mathematical formula with 'x' as the variable
    /// - Parameters:
    ///   - formula: A string containing a mathematical formula (e.g., "x + 3", "x * 2 + 5")
    ///   - x: The value to substitute for 'x' in the formula
    /// - Returns: The result of the evaluated formula
    static func evaluate(formula: String, x: Decimal) throws -> Decimal {
        let context = JSContext()!
        
        var evaluationError: Error?
        context.exceptionHandler = { _, exception in
            if let exception = exception {
                evaluationError = FormulaError.evaluationError(exception.toString())
            }
        }
        
        let xValue = NSDecimalNumber(decimal: x).doubleValue
        let formulaWithValue = formula.replacingOccurrences(of: "x", with: "\(xValue)")
        
        if let result = context.evaluateScript(formulaWithValue),
           !result.isUndefined {
            let doubleResult = result.toDouble()
            return Decimal(doubleResult)
        }
        
        if let error = evaluationError {
            throw error
        }
        
        throw FormulaError.evaluationError("Unable to evaluate formula")
    }
    

    static func isValid(formula: String) -> Bool {
        let context = JSContext()!
        
        var isValid = true
        context.exceptionHandler = { _, _ in
            isValid = false
        }
        
        let testFormula = formula.replacingOccurrences(of: "x", with: "1")
        let _ = context.evaluateScript(testFormula)
        
        return isValid
    }
} 
