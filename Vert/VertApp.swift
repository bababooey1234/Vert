import SwiftUI
import SwiftData

@main
struct VertApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(appContainer)
    }
}
