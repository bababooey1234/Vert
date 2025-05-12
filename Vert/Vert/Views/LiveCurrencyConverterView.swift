//
//  LiveC.swift
//  Vert
//
//  Created by Michael Zervos on 12/5/2025.
//

import SwiftUI

struct LiveCurrencyConverterView: View {
    @State private var amountText: String = ""
    @State private var baseCurrency: String = "USD"
    @State private var targetCurrency: String = "AUD"
    @State private var result: Double?
    @State private var isLoading = false
    @State private var errorMessage: String?

    let availableCurrencies = ["USD", "AUD", "EUR", "GBP", "JPY"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Live Currency Converter")
                .font(.title2)
                .bold()

            TextField("Amount", text: $amountText)
                .keyboardType(.decimalPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Picker("From", selection: $baseCurrency) {
                    ForEach(availableCurrencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())

                Text("to")

                Picker("To", selection: $targetCurrency) {
                    ForEach(availableCurrencies, id: \.self) { currency in
                        Text(currency)
                    }
                }
                .pickerStyle(MenuPickerStyle())
            }

            Button(action: performConversion) {
                Text("Convert")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            if isLoading {
                ProgressView()
            } else if let result = result {
                Text("Converted Amount: \(String(format: "%.2f", result)) \(targetCurrency)")
                    .font(.headline)
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
    }

    func performConversion() {
        guard let amount = Double(amountText) else {
            errorMessage = "Please enter a valid number"
            result = nil
            return
        }

        isLoading = true
        errorMessage = nil
        result = nil

        CurrencyAPI.shared.fetchRates(baseCurrency: baseCurrency) { apiResult in
            DispatchQueue.main.async {
                isLoading = false
                switch apiResult {
                case .success(let rates):
                    if let rate = rates[targetCurrency] {
                        result = amount * rate
                    } else {
                        errorMessage = "Rate for \(targetCurrency) not found"
                    }
                case .failure(let error):
                    errorMessage = "API Error: \(error.localizedDescription)"
                }
            }
        }
    }
}
