//
//  CurrencyConverterView.swift
//  Vert
//
//  Created by Michael Zervos on 13/5/2025.
//
import SwiftUI

struct CurrencyConverterView: View {
    @StateObject private var viewModel = CurrencyViewModel()
    @State private var amount: String = ""
    @State private var convertedAmount: String = ""
    @State private var isConverting = false

    @State private var showFromPicker = false
    @State private var showToPicker = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Amount")) {
                    TextField("Enter amount", text: $amount)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("From Currency")) {
                    Button(action: { showFromPicker = true }) {
                        HStack {
                            Text(viewModel.fromCurrency?.code ?? "Select")
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                    }
                }

                Section(header: Text("To Currency")) {
                    Button(action: { showToPicker = true }) {
                        HStack {
                            Text(viewModel.toCurrency?.code ?? "Select")
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                    }
                }

                Section {
                    Button(action: convertCurrency) {
                        HStack {
                            Spacer()
                            Text(isConverting ? "Converting..." : "Convert")
                                .bold()
                            Spacer()
                        }
                    }
                    .disabled(isConverting || viewModel.fromCurrency == nil || viewModel.toCurrency == nil)
                }

                if !convertedAmount.isEmpty {
                    Section(header: Text("Converted Amount")) {
                        Text("\(convertedAmount) \(viewModel.toCurrency?.code ?? "")")
                            .font(.title2)
                            .monospacedDigit()
                    }
                }
            }
            .navigationTitle("Currency Converter")
            .onAppear {
                viewModel.loadAllCurrencies()
            }
            .sheet(isPresented: $showFromPicker) {
                CurrencyPickerView(
                    selectedCurrency: $viewModel.fromCurrency,
                    currencies: viewModel.allCurrencies
                )
            }
            .sheet(isPresented: $showToPicker) {
                CurrencyPickerView(
                    selectedCurrency: $viewModel.toCurrency,
                    currencies: viewModel.allCurrencies
                )
            }
        }
    }

    private func convertCurrency() {
        guard let amountValue = Double(amount),
              let from = viewModel.fromCurrency?.code,
              let to = viewModel.toCurrency?.code else {
            convertedAmount = "Invalid input"
            return
        }

        isConverting = true
        CurrencyAPI.shared.fetchRates(baseCurrency: from) { result in
            DispatchQueue.main.async {
                isConverting = false
                switch result {
                case .success(let rates):
                    if let rate = rates[to] {
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
