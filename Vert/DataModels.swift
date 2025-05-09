import Foundation

struct Category: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var units: [Unit]
    
    init() {
        id = UUID()
        name = "New Category"
        units = []
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct Unit: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var symbol: String
    var useMetricPrefixes: Bool
    var factor: Decimal?
    var numerator: [Int]
    var denominator: [Int]
    
    init(category: Category) {
        id = UUID()
        name = "New Unit"
        symbol = "symbol"
        useMetricPrefixes = false
        factor = nil
        numerator = []
        denominator = []
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

var categories: [Category] = load("SystemData.json")

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data
    
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Coudln't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error.localizedDescription)")
    }
}

