//
//  Event.swift
//  MyAutomobile
//
//  Created by Radu Dan on 20.04.2022.
//

import Foundation

struct Event {
    let id: UUID
    var localCalendarID: String?
    let date: Date
    let description: String
    let recurrence: Recurrence
    
    init(id: UUID = .init(), localCalendarID: String? = nil, date: Date, description: String, recurrence: Recurrence = .once) {
        self.id = id
        self.localCalendarID = localCalendarID
        self.date = date
        self.description = description
        self.recurrence = recurrence
    }
}

extension Event {
    enum Recurrence: String, Codable, CaseIterable {
        case once
        case weekly
        case monthly
        case quarterly
        case everySixMonths
        case yearly
        
        var localizedKey: String {
            switch self {
            case .once:
                return String(localized: "One time")
            case .weekly:
                return String(localized: "Weekly")
            case .monthly:
                return String(localized: "Monthly")
            case .quarterly:
                return String(localized: "Every quarter")
            case .everySixMonths:
                return String(localized: "Every six months")
            case .yearly:
                return String(localized: "Every year")
            }
        }
        
        var longLocalizedKey: String {
            switch self {
            case .once:
                return String(localized: "Recurrence: one time")
            case .weekly:
                return String(localized: "Recurrence: weekly")
            case .monthly:
                return String(localized: "Recurrence: monthly")
            case .quarterly:
                return String(localized: "Recurrence: every quarter")
            case .everySixMonths:
                return String(localized: "Recurrence: every six months")
            case .yearly:
                return String(localized: "Recurrence: every year")
            }
        }
    }
}

extension Event: Identifiable {}

extension Event: Hashable {}

extension Event: Codable {}
