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
    let distance = Category(name: "Distance")
    distance.units.append(Unit(category: distance, name: "Metre", symbol: "m", useMetricPrefixes: true, factor: 1, numerator: [], denominator: []))
    distance.units.append(Unit(category: distance, name: "Foot", symbol: "'", useMetricPrefixes: false, factor: 0.3048, numerator: [1], denominator: []))

    let time = Category(name: "Time")
    time.units.append(Unit(category: time, name: "Second", symbol: "s", useMetricPrefixes: false, factor: 1, numerator: [], denominator: []))

    let speed = Category(name: "Speed")
    speed.units.append(Unit(category: speed, name: "Metres per Second", symbol: "m/s", useMetricPrefixes: true, factor: 1, numerator: [1], denominator: [3]))

    let categories = [
        distance,
        time,
        speed
    ]
    
    for category in categories {
        container.mainContext.insert(category)
    }
}
