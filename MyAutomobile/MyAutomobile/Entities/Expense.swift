//
//  Expense.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import Foundation

struct Expense {
    let id: UUID
    let vehicleID: UUID
    let date: Date
    let odometerReading: Int?
    let expenseType: ExpenseType
    let cost: Double
    let comment: String?
}

extension Expense: Codable {}

extension Expense: Equatable {}

extension Expense: Hashable {}
