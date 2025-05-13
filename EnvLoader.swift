//
//  EnvLoader.swift
//  Vert
//
//  Created by Michael Zervos on 13/5/2025.
//

import Foundation

enum EnvLoader {
    static func get(_ key: String) -> String? {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else { return nil }
        let url = URL(fileURLWithPath: path)
        guard let content = try? String(contentsOf: url) else { return nil }

        for line in content.components(separatedBy: .newlines) {
            let parts = line.components(separatedBy: "=")
            if parts.count == 2, parts[0].trimmingCharacters(in: .whitespaces) == key {
                return parts[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }

        return nil
    }
}
