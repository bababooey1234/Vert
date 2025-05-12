import SwiftUI
import SwiftData

struct UnitDetailView: View {
    var unit: Unit
    var body: some View {
        Text("Hello, World! I'm \(unit.name)")
    }
}

#Preview {
    UnitDetailView(unit: Unit(Category()))
}
