//
//  currencyAPI.swift
//  Vert
//
//  Created by Michael Zervos on 12/5/2025.
//
import Foundation

// Struct for caching rates with timestamps
struct CurrencyCache {
    let rates: [String: Double]
    let timestamp: Date
}

// Singleton service to interact with CurrencyAPI with caching support
class CurrencyAPI {
    static let shared = CurrencyAPI()
    private let apiKey = "cur_live_3qNP5bdIEApBLT7Zp0tyUAuWB3qsR3bxnhZroogL"
    private let baseURL = "https://api.currencyapi.com/v3/latest"

    private var cache: [String: CurrencyCache] = [:]

    func fetchRates(baseCurrency: String = "USD", completion: @escaping (Result<[String: Double], Error>) -> Void) {
        // Return cached result if still valid (within 5 minutes)
        if let cached = cache[baseCurrency], Date().timeIntervalSince(cached.timestamp) < 300 {
            completion(.success(cached.rates))
            return
        }

        guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&base_currency=\(baseCurrency)") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if let cached = self.cache[baseCurrency] {
                    print("Using cached rates due to API failure.")
                    completion(.success(cached.rates))
                } else {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                if let cached = self.cache[baseCurrency] {
                    print("Using cached rates due to no data.")
                    completion(.success(cached.rates))
                } else {
                    completion(.failure(NSError(domain: "No data received", code: -1)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(CurrencyResponse.self, from: data)
                let rates = decoded.data.mapValues { $0.value }
                self.cache[baseCurrency] = CurrencyCache(rates: rates, timestamp: Date())
                completion(.success(rates))
            } catch {
                if let cached = self.cache[baseCurrency] {
                    print("Using cached rates due to decoding error.")
                    completion(.success(cached.rates))
                } else {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
