//
//  Currency.swift
//  Vert
//
//  Created by Michael Zervos on 12/5/2025.
//

import Foundation

// Represents the structure of the JSON returned by CurrencyAPI
struct CurrencyResponse: Codable {
    let data: [String: CurrencyValue]
}

struct CurrencyValue: Codable {
    let value: Double
}
