//
//  ResourceLoader.swift
//  MyAutomobile
//
//  Created by Radu Dan on 11.02.2026.
//

import Foundation

enum ResourceLoader {
    static var resourceBundle: Bundle { Bundle(for: DataLoaderBundleToken.self) }

    static func json(supportedLocale: SupportedLocale = .english, resource: ResourceEntity) -> String? {
        guard let url = resourceBundle.url(forResource: resource.rawValue, withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let localeArray = jsonDict[supportedLocale.rawValue] else {
            return nil
        }

        guard let localeData = try? JSONSerialization.data(withJSONObject: localeArray),
              let jsonString = String(data: localeData, encoding: .utf8) else {
            return nil
        }

        return jsonString
    }
}
