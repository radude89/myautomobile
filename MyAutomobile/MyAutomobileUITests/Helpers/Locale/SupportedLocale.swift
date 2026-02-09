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
}

extension SupportedLocale {
    init(systemLocale: Locale) {
        switch systemLocale.language.languageCode {
        case .english: self = .english
        case .german: self = .german
        case .spanish: self = .spanish
        case .romanian: self = .romanian
        case .french: self = .french
        case .italian: self = .italian
        default: self = .english
        }
    }
}

extension SupportedLocale {
    func objectsKeyPath<T: Decodable>() -> KeyPath<ModelJSON<T>, [T]> {
        switch self {
        case .english: return \.en
        case .french: return \.fr
        case .italian: return \.it
        case .spanish: return \.es
        case .romanian: return \.ro
        case .german: return \.de
        }
    }
}

