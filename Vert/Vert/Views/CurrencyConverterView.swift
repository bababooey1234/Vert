//
//  Untitled.swift
//  Vert
//
//  Created by Michael Zervos on 12/5/2025.
//

import SwiftUI

struct CurrencyConverterView: View {
    @State private var amount: String = ""
    @State private var fromCurrency: String = "EUR"
    @State private var toCurrency: String = "GBP"
    @State private var convertedAmount: String = ""
    @State private var isConverting = false

    let currencies = ["USD", "EUR", "GBP", "AUD", "JPY", "CAD"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Live Currency Converter")
                .font(.headline)

            TextField("Enter amount", text: $amount)
                .keyboardType(.decimalPad)
                .padding()
                .border(Color.gray)

            HStack {
                Picker("From", selection: $fromCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Text("to")

                Picker("To", selection: $toCurrency) {
                    ForEach(currencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Button(action: convertCurrency) {
                Text(isConverting ? "Converting..." : "Convert")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(isConverting)

            if !convertedAmount.isEmpty {
                Text("Converted Amount: \(convertedAmount) \(toCurrency)")
                    .font(.title2)
                    .padding()
            }

            Spacer()
        }
        .padding()
    }

    private func convertCurrency() {
        guard let amountValue = Double(amount) else {
            convertedAmount = "Invalid amount"
            return
        }

        isConverting = true
        CurrencyAPI.shared.fetchRates(baseCurrency: fromCurrency) { result in
            DispatchQueue.main.async {
                isConverting = false
                switch result {
                case .success(let rates):
                    if let rate = rates[toCurrency] {
                        let converted = amountValue * rate
                        convertedAmount = String(format: "%.2f", converted)
                    } else {
                        convertedAmount = "Rate not found"
                    }
                case .failure(let error):
                    convertedAmount = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
