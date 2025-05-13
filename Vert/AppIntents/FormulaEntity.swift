import AppIntents
import SwiftData
import SwiftUI

struct FormulaEntity: AppEntity {
    var id: UUID
    var name: String
    var formula: String
    
    static var defaultQuery = FormulaEntityQuery()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: LocalizedStringResource("Formula"),
            numericFormat: "\(placeholder: .int) formulas"
        )
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: name)
    }
}

struct FormulaEntityQuery: EnumerableEntityQuery {
    @MainActor func entities(for identifiers: [FormulaEntity.ID]) async throws -> [FormulaEntity] {
        let context = ModelContext(appContainer)
        let formulas = try context
            .fetch(FetchDescriptor<CustomFormula>())
            .filter { identifiers.contains($0.id) }
            .map { FormulaEntity(id: $0.id, name: $0.name, formula: $0.formula) }
        return formulas
    }
    
    @MainActor func allEntities() async throws -> [FormulaEntity] {
        let context = ModelContext(appContainer)
        let formulas = try context
            .fetch(FetchDescriptor<CustomFormula>())
            .map { FormulaEntity(id: $0.id, name: $0.name, formula: $0.formula) }
        return formulas
    }
}
