//
//  Vehicle.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct Vehicle {
    let id: UUID
    var make: String
    var model: String
    var numberPlate: String
    var color: Color
    var customFields: [String: FieldDetails]
    let dateCreated: Date
    var events: [Event]
    var expenses: [Expense]
    
    init(id: UUID = .init(),
         make: String,
         model: String,
         numberPlate: String,
         color: Color,
         customFields: [String : FieldDetails] =  [:],
         dateCreated: Date = .now,
         events: [Event] = [],
         expenses: [Expense] = []) {
        self.id = id
        self.make = make
        self.model = model
        self.numberPlate = numberPlate
        self.color = color
        self.customFields = customFields
        self.dateCreated = dateCreated
        self.events = events
        self.expenses = expenses
    }
}

extension Vehicle {
    struct FieldDetails {
        let dateCreated: Date
        let key: String
        let value: String
    }
}

extension Vehicle: Equatable, Identifiable, Hashable, Codable {}

extension Vehicle.FieldDetails: Equatable, Hashable, Codable {}

extension Vehicle.FieldDetails: Comparable {
    static func < (lhs: Vehicle.FieldDetails, rhs: Vehicle.FieldDetails) -> Bool {
        lhs.dateCreated < rhs.dateCreated
    }
}
