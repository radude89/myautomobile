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
    private let numberFormatter = NumberFormatter()
    private static let fallbackExpenseTypeIndex = 3
    
    let expenseTypes = ExpenseType.allCases
    let showOnlyMaintenanceItems: Bool
    
    init(vehicles: Vehicles, 
         vehicleID: UUID,
         showOnlyMaintenanceItems: Bool) {
        self.vehicles = vehicles
        self.vehicleID = vehicleID
        self.showOnlyMaintenanceItems = showOnlyMaintenanceItems
    }
    
    var initialExpenseTypeIndex: Int {
        expenseTypes.firstIndex(
            of: showOnlyMaintenanceItems ? .maintenance : .fuel
        ) ?? Self.fallbackExpenseTypeIndex
    }
    
    func saveExpense(
        expenseTypeIndex: Int,
        date: Date,
        odometerReadingDescription: String,
        costDescription: String,
        commentDescription: String
    ) {
        let number = numberFormatter.number(from: costDescription)
        guard let cost = number?.doubleValue else {
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
        let odometer = numberFormatter.number(from: odometerReadingDescription)?.intValue
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
