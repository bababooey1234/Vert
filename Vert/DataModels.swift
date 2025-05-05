import Foundation

struct SystemData: Codable {
    let categories: [Category]
    let units: [Unit]
}

struct Category: Identifiable, Codable {
    let id: Int
    let name: String
}

struct Unit: Identifiable, Codable {
    let id: Int
    let categoryId: Int
    let name: String
    let symbol: String
    let useMetricPrefixes: Bool
    let factor: Decimal?
    let numerator: [Int]
    let denominator: [Int]
}

var systemData: SystemData = load("SystemData.json")

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

