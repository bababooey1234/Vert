import AppIntents
import SwiftData
import SwiftUI

struct FormulaEntity: AppEntity {
    var id: UUID
    var name: String
    
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

struct FormulaEntityQuery: EntityQuery {
    @Query(sort: \CustomFormula.name) var formulas: [CustomFormula]
    func entities(for identifiers: [FormulaEntity.ID]) async throws -> [FormulaEntity] {
        return formulas.filter { identifiers.contains($0.id) }.map { FormulaEntity(id: $0.id, name: $0.name) }
    }
}
