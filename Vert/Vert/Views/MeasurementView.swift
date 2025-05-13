import SwiftUI
import SwiftData

struct MeasurementView: View {
    @Query var categories: [Category]
    var body: some View {
        VStack {
            List(categories) { category in
                Text(category.name)
            }
            Text("^ Categories   Units v")
            List(categories.flatMap(\.units)) { unit in
                Text(unit.name)
            }
        }
        .padding()
    }
}

#Preview {
    MeasurementView()
}
