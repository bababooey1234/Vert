//
//  EnviromentLoader.swift
//  Vert
//
//  Created by Michael Zervos on 13/5/2025.
//
import Foundation

class EnvironmentLoader {
    static let shared = EnvironmentLoader()

    private var environment: [String: String] = [:]

    private init() {
        loadEnvFile()
    }

    private func loadEnvFile() {
        guard let url = Bundle.main.url(forResource: ".env", withExtension: nil),
              let content = try? String(contentsOf: url) else {
            print("⚠️ .env file not found or unreadable")
            return
        }

        content.split(separator: "\n").forEach { line in
            let parts = line.split(separator: "=", maxSplits: 1)
            if parts.count == 2 {
                let key = String(parts[0]).trimmingCharacters(in: .whitespaces)
                let value = String(parts[1]).trimmingCharacters(in: .whitespaces)
                environment[key] = value
            }
        }
    }

    func get(_ key: String) -> String? {
        environment[key]
    }
}
