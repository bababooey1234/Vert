import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            List(systemData.categories) { category in
                Text(category.name)
            }
            Text("^ Categories   Units v")
            List(systemData.units) { unit in
                Text(unit.name)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
