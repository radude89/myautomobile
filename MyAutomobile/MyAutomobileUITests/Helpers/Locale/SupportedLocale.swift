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
    
    var vehiclesKeyPath: KeyPath<VehiclesJSON, [VehicleData]> {
        switch self {
        case .english: \.en
        case .french: \.fr
        case .italian: \.it
        case .spanish: \.es
        case .romanian: \.ro
        case .german: \.de
        }
    }
    
    var eventsKeyPath: KeyPath<EventsJSON, [EventData]> {
        switch self {
        case .english: \.en
        case .french: \.fr
        case .italian: \.it
        case .spanish: \.es
        case .romanian: \.ro
        case .german: \.de
        }
    }
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
