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
        
        // Define y and z variables for multi-parameter formulas
        context.evaluateScript("var y = 0; var z = 0;")
        
        // Add math library functions to the context
        setupMathFunctions(context: context)
        
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
    
    /// Evaluates a multi-parameter formula using up to three parameters (x, y, z)
    /// - Parameters:
    ///   - formula: A string containing a mathematical formula that can use x, y, and z
    ///   - parameters: Array of parameter values (up to 3)
    /// - Returns: The result of the evaluated formula
    static func evaluateMultiParam(formula: String, parameters: [Decimal]) throws -> Decimal {
        let context = JSContext()!
        
        // Add math library functions to the context
        setupMathFunctions(context: context)
        
        var evaluationError: Error?
        context.exceptionHandler = { _, exception in
            if let exception = exception {
                evaluationError = FormulaError.evaluationError(exception.toString())
            }
        }
        
        // Set variables based on parameters array
        if parameters.count > 0 {
            let xValue = NSDecimalNumber(decimal: parameters[0]).doubleValue
            context.evaluateScript("var x = \(xValue);")
        } else {
            context.evaluateScript("var x = 0;")
        }
        
        if parameters.count > 1 {
            let yValue = NSDecimalNumber(decimal: parameters[1]).doubleValue
            context.evaluateScript("var y = \(yValue);")
        } else {
            context.evaluateScript("var y = 0;")
        }
        
        if parameters.count > 2 {
            let zValue = NSDecimalNumber(decimal: parameters[2]).doubleValue
            context.evaluateScript("var z = \(zValue);")
        } else {
            context.evaluateScript("var z = 0;")
        }
        
        if let result = context.evaluateScript(formula),
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
        
        // Add math library functions to the context
        setupMathFunctions(context: context)
        
        var isValid = true
        context.exceptionHandler = { _, _ in
            isValid = false
        }
        
        // Define all possible variables
        context.evaluateScript("var x = 1; var y = 1; var z = 1;")
        
        let _ = context.evaluateScript(formula)
        
        return isValid
    }
    
    private static func setupMathFunctions(context: JSContext) {
        // Make all JavaScript Math functions available
        context.evaluateScript("""
            var sqrt = Math.sqrt;
            var pow = Math.pow;
            var exp = Math.exp;
            var log = Math.log;
            var log10 = Math.log10;
            var sin = Math.sin;
            var cos = Math.cos;
            var tan = Math.tan;
            var asin = Math.asin;
            var acos = Math.acos;
            var atan = Math.atan;
            var atan2 = Math.atan2;
            var abs = Math.abs;
            var floor = Math.floor;
            var ceil = Math.ceil;
            var round = Math.round;
            var max = Math.max;
            var min = Math.min;
            var cbrt = Math.cbrt;
            var PI = Math.PI;
            var E = Math.E;
            
            // Additional functions that might be needed
            function factorial(n) {
                if (n <= 1) return 1;
                return n * factorial(n - 1);
            }
            
            // Cube root fallback for older JS engines
            if (typeof cbrt !== 'function') {
                cbrt = function(x) {
                    return Math.pow(x, 1/3);
                };
            }
        """)
    }
} 
