//
//  DataLoader.swift
//  MyAutomobile
//
//  Created by Radu Dan on 14.07.2025.
//

import XCTest

protocol DataLoader {
    static func loadJSON<T: Decodable>(resource: ResourceEntity) -> T?
}

extension DataLoader {
    static var resourceBundle: Bundle { Bundle(for: DataLoaderBundleToken.self) }

    static func loadJSON<T: Decodable>(resource: ResourceEntity) -> T? {
        guard let url = resourceBundle.url(forResource: resource.rawValue, withExtension: "json") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            print("Decoding error for \(resource).json: \(error)")
            print("JSON was: \(String(data: data, encoding: .utf8) ?? "N/A")")
            return nil
        }
    }
}
