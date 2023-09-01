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
    
    init(id: UUID = .init(), date: Date, description: String) {
        self.id = id
        self.date = date
        self.description = description
    }
}

extension Event: Identifiable {}

extension Event: Hashable {}

extension Event: Codable {}
