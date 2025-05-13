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
        // Create a JavaScript context for evaluating the formula
        let context = JSContext()!
        
        // Set up error handling
        var evaluationError: Error?
        context.exceptionHandler = { _, exception in
            if let exception = exception {
                evaluationError = FormulaError.evaluationError(exception.toString())
            }
        }
        
        // Replace all 'x' variables with the actual value
        let xValue = NSDecimalNumber(decimal: x).doubleValue
        let formulaWithValue = formula.replacingOccurrences(of: "x", with: "\(xValue)")
        
        // Evaluate the formula
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
    
    /// Validates if a formula string is properly formatted
    /// - Parameter formula: The formula string to validate
    /// - Returns: True if the formula is valid, false otherwise
    static func isValid(formula: String) -> Bool {
        let context = JSContext()!
        
        // Try to evaluate with a test value
        var isValid = true
        context.exceptionHandler = { _, _ in
            isValid = false
        }
        
        // Replace x with a test value and see if it evaluates
        let testFormula = formula.replacingOccurrences(of: "x", with: "1")
        let _ = context.evaluateScript(testFormula)
        
        return isValid
    }
} 