//
//  Expense.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import Foundation

struct Expense {
    let id: UUID
    let date: Date
    let odometerReading: Int?
    let expenseType: ExpenseType
    let cost: Double
    let comment: String?
    
    init(id: UUID = .init(),
         date: Date,
         odometerReading: Int?,
         expenseType: ExpenseType,
         cost: Double,
         comment: String? = nil) {
        self.id = id
        self.date = date
        self.odometerReading = odometerReading
        self.expenseType = expenseType
        self.cost = cost
        self.comment = comment
    }
}

extension Expense: Identifiable {}

extension Expense: Codable {}

extension Expense: Equatable {}

extension Expense: Hashable {}
