//
//  Event.swift
//  MyAutomobile
//
//  Created by Radu Dan on 20.04.2022.
//

import Foundation

struct Event {
    let id = UUID()
    let date: Date
    let description: String
}

extension Event: Identifiable {}

extension Event: Hashable {}
