import SwiftUI

struct CurrencyView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var baseCurrency = "USD"

    var body: some View {
        NavigationView {
            VStack {
                TextField("Base Currency (e.g. USD)", text: $baseCurrency)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Load Rates") {
                    viewModel.loadRates(baseCurrency: baseCurrency)
                }
                .padding()

                if let error = viewModel.errorMessage {
                    Text("Error: \(error)")
                        .foregroundColor(.red)
                        .padding()
                }

                List(viewModel.rates.sorted(by: { $0.key < $1.key }), id: \.key) { currency, rate in
                    HStack {
                        Text(currency)
                        Spacer()
                        Text(String(format: "%.2f", rate))
                    }
                }
            }
            .navigationTitle("Currency Converter")
        }
    }
}
