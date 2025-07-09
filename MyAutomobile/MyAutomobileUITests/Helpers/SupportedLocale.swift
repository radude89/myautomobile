//
//  SupportedLocale.swift
//  MyAutomobile
//
//  Created by Radu Dan on 08.07.2025.
//

import Foundation

enum SupportedLocale: String, CaseIterable {
    case english = "en"
    case french = "fr"
    case italian = "it"
    case spanish = "es"
    case romanian = "ro"
    case german = "de"
    
    var keyPath: KeyPath<VehiclesJSON, [VehicleData]> {
        switch self {
        case .english: \.en
        case .french: \.fr
        case .italian: \.it
        case .spanish: \.es
        case .romanian: \.ro
        case .german: \.de
        }
    }
    
    init?(locale: Locale) {
        guard let languageCode = locale.language.languageCode?.identifier else {
            return nil
        }
        
        self.init(rawValue: languageCode)
    }
}
