import SwiftUI

enum Tabs {
    case currency
    case measurement
    case formulas
}

struct ContentView: View {
    @State private var selectedTab = Tabs.formulas
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Currency", systemImage: "dollarsign.square", value: .currency) {
                CurrencyView()
            }
            Tab("Measurement", systemImage: "ruler", value: .measurement) {
                MeasurementView()
            }
            Tab("Formulas", systemImage: "function", value: .formulas) {
                CustomFormulaView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
