import SwiftUI

enum Tabs {
    case currency
    case measurement
    case customise
}

struct ContentView: View {
    @State private var selectedTab = Tabs.measurement
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Currency", systemImage: "dollarsign.square", value: .currency) {
                CurrencyView()
            }
            Tab("Measurement", systemImage: "ruler", value: .measurement) {
                MeasurementView()
            }
            Tab("Customise", systemImage: "plus", value: .customise) {
                CustomiseView()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
