//
//  Event.swift
//  MyAutomobile
//
//  Created by Radu Dan on 20.04.2022.
//

import Foundation

struct Event {
    let id: UUID
    let date: Date
    let description: String
    let recurrence: Recurrence
    
    init(id: UUID = .init(), date: Date, description: String, recurrence: Recurrence = .once) {
        self.id = id
        self.date = date
        self.description = description
        self.recurrence = recurrence
    }
}

extension Event {
    enum Recurrence: String, Codable, CaseIterable {
        case once = "One time"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case quarterly = "Every quarter"
        case everySixMonths = "Every six months"
        case yearly = "Every year"
    }
}

extension Event: Identifiable {}

extension Event: Hashable {}

extension Event: Codable {}
