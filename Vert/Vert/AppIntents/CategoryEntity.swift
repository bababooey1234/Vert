import AppIntents
import SwiftData
import SwiftUI

struct CategoryEntity: AppEntity {
    var id: UUID
    var name: String
    
    static var defaultQuery = CategoryEntityQuery()
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(
            name: LocalizedStringResource("Category"),
            numericFormat: "\(placeholder: .int) categories"
        )
    }
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: name)
    }
}

struct CategoryEntityQuery: EntityQuery {
    @Query(sort: \Category.name) var categories: [Category]
    func entities(for identifiers: [CategoryEntity.ID]) async throws -> [CategoryEntity] {
        return categories.filter { identifiers.contains($0.id) }.map { CategoryEntity(id: $0.id, name: $0.name) }
    }
}
