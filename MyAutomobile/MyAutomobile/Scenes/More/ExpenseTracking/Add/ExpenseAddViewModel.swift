//
//  ExpenseAddViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 05.02.2024.
//

import SwiftUI

final class ExpenseAddViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    private let vehicleID: UUID
    
    let expenseTypes = ExpenseType.allCases
    
    init(vehicles: Vehicles, vehicleID: UUID) {
        self.vehicles = vehicles
        self.vehicleID = vehicleID
    }
    
    func saveExpense(
        expenseTypeIndex: Int,
        date: Date,
        odometerReadingDescription: String,
        costDescription: String,
        commentDescription: String
    ) {
        guard let cost = Double(costDescription) else {
            return
        }
        guard let vehicleIndex = vehicles.items.firstIndex(where: { vehicleID == $0.id }) else {
            return
        }
        
        let expense = makeExpense(
            expenseTypeIndex: expenseTypeIndex,
            date: date,
            odometerReadingDescription: odometerReadingDescription,
            cost: cost,
            commentDescription: commentDescription
        )
        
        vehicles.items[vehicleIndex].expenses.append(expense)
    }
}

// MARK: - Private
private extension ExpenseAddViewModel {
    func makeExpense(
        expenseTypeIndex: Int,
        date: Date,
        odometerReadingDescription: String,
        cost: Double,
        commentDescription: String
    ) -> Expense {
        let odometer = odometerReadingDescription.isEmpty ? nil : Int(odometerReadingDescription)
        let comment = commentDescription.isEmpty ? nil : commentDescription
        return Expense(
            date: date,
            odometerReading: odometer,
            expenseType: expenseTypes[expenseTypeIndex],
            cost: cost,
            comment: comment
        )
    }
}
