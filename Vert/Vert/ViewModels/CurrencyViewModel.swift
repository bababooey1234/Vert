//import SwiftUI
import Foundation

class CurrencyViewModel: ObservableObject {
    @Published var rates: [String: Double] = [:]
    @Published var errorMessage: String?
    
    func loadRates(baseCurrency: String = "USD") {
        CurrencyAPI.shared.fetchRates(baseCurrency: baseCurrency) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let rates):
                    self.rates = rates
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}
//  Untitled.swift
//  Vert
//
//  Created by Michael Zervos on 12/5/2025.
//

