//
//  currencyAPI.swift
//  Vert
//
//  Created by Michael Zervos on 12/5/2025.
//
import Foundation

struct CurrencyMetadataResponse: Codable {
    let data: [String: CurrencyInfo]
}

struct CurrencyInfo: Codable, Hashable {
    let symbol: String
    let name: String
    let symbol_native: String
    let decimal_digits: Int
    let rounding: Int
    let code: String
    let name_plural: String
    let type: String
    let countries: [String]
}



class CurrencyAPI {
    static let shared = CurrencyAPI()

    private var apiKey: String {
        EnvLoader.get("CURRENCY_API_KEY") ?? ""
    }

    private var allCurrenciesCache: [CurrencyInfo] = []

    func fetchAllCurrencies(completion: @escaping (Result<[CurrencyInfo], Error>) -> Void) {
        if !allCurrenciesCache.isEmpty {
            completion(.success(allCurrenciesCache))
            return
        }

        guard let url = URL(string: "https://api.currencyapi.com/v3/currencies?apikey=\(apiKey)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CurrencyMetadataResponse.self, from: data)
                let allCurrencies = decoded.data.map { $0.value }.sorted { $0.code < $1.code }
                self.allCurrenciesCache = allCurrencies
                completion(.success(allCurrencies))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    struct CurrencyResponse: Codable {
        let data: [String: CurrencyValue]
    }

    struct CurrencyValue: Codable {
        let value: Double
    }

    func fetchRates(baseCurrency: String, completion: @escaping (Result<[String: Double], Error>) -> Void) {
        guard let url = URL(string: "https://api.currencyapi.com/v3/latest?apikey=\(apiKey)&base_currency=\(baseCurrency)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1)))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                let rates = decoded.data.mapValues { $0.value }
                completion(.success(rates))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
