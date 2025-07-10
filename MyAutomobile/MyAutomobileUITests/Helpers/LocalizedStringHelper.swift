//
//  LocalizedStringHelper.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.07.2025.
//

import Foundation

enum LocalizedStringHelper {
    static func loadString(_ key: String, locale: SupportedLocale) -> String {
        let bundle = Bundle(for: VehicleUITests.self)
        if let path = bundle.path(forResource: locale.rawValue, ofType: "lproj"),
           let localeBundle = Bundle(path: path) {
            return NSLocalizedString(key, bundle: localeBundle, comment: "")
        }
        return NSLocalizedString(key, comment: "")
    }
}
