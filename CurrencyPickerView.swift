//
//  CurrencyPickerView.swift
//  Vert
//
//  Created by Michael Zervos on 13/5/2025.
//

import SwiftUI

struct CurrencyPickerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCurrency: CurrencyInfo?
    let currencies: [CurrencyInfo]

    @State private var searchText: String = ""

    var filteredCurrencies: [CurrencyInfo] {
        if searchText.isEmpty {
            return currencies
        } else {
            return currencies.filter {
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCurrencies, id: \.code) { currency in
                    Button(action: {
                        selectedCurrency = currency
                        dismiss()
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(currency.code) – \(currency.name)")
                                Text(currency.symbol_native)
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            if currency == selectedCurrency {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Select Currency")
        }
    }
}
