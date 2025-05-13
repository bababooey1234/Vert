//
//  Untitled.swift
//  Vert
//
//  Created by Michael Zervos on 13/5/2025.
//

import Foundation
import SwiftUI

@MainActor
class CurrencyViewModel: ObservableObject {
    @Published var allCurrencies: [CurrencyInfo] = []
    @Published var fromCurrency: CurrencyInfo?
    @Published var toCurrency: CurrencyInfo?

    func loadAllCurrencies() {
        CurrencyAPI.shared.fetchAllCurrencies { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let currencies):
                    self.allCurrencies = currencies
                    self.fromCurrency = currencies.first(where: { $0.code == "USD" })
                    self.toCurrency = currencies.first(where: { $0.code == "AUD" })
                case .failure(let error):
                    print("Failed to load currencies: \(error)")
                }
            }
        }
    }
}
