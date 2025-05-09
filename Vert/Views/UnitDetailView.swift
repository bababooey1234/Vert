import SwiftUI

struct UnitDetailView: View {
    var unit: Unit
    var body: some View {
        Text("Hello, World! I'm \(unit.name)")
    }
}

#Preview {
    UnitDetailView(unit: categories[0].units[0])
}
