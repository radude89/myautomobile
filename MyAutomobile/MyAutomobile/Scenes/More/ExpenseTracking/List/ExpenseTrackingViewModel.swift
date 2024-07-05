//
//  ExpenseTrackingViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

@MainActor
final class ExpenseTrackingViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    
    @Published private(set) var expenses: [Expense] = []
    
    let vehicleID: UUID
    let showOnlyMaintenanceItems: Bool
    
    init(vehicles: Vehicles, 
         vehicleID: UUID,
         showOnlyMaintenanceItems: Bool = false) {
        self.vehicles = vehicles
        self.vehicleID = vehicleID
        self.showOnlyMaintenanceItems = showOnlyMaintenanceItems
        reloadExpenses()
    }
    
    var shouldDisplayEdit: Bool {
        guard let vehicle else {
            return false
        }

        return !vehicle.expenses.isEmpty
    }
    
    private var vehicle: Vehicle? {
        vehicles.items.first { $0.id == vehicleID }
    }
    
    private var vehicleIndex: Int? {
        vehicles.items.firstIndex(where: { $0.id == vehicleID })
    }
    
    var hasDeletedVehicle: Bool {
        vehicle == nil
    }
    
    func reloadExpenses() {
        guard let vehicleIndex else {
            expenses = []
            return
        }
        
        expenses = if !showOnlyMaintenanceItems {
            vehicles.items[vehicleIndex].expenses
                .sorted { $0.date > $1.date }
        } else {
            vehicles.items[vehicleIndex].expenses
                .filter { $0.expenseType == .maintenance }
                .sorted { $0.date > $1.date }
        }
    }

    var formattedTotalCost: String {
        let formatter = NumberFormatterFactory.makeAmountFormatter()
        let total = expenses.reduce(0.0) { $0 + $1.cost }
        return formatter.string(from: NSNumber(value: total)) ?? "0"
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        guard let vehicleIndex,
              let indexOfExpenseToDelete = indexSet.first else {
            return
        }
        
        let expenseToDelete = expenses[indexOfExpenseToDelete]
        guard let expenseIndex = vehicles.items[vehicleIndex].expenses.firstIndex(
            where: { $0.id == expenseToDelete.id }
        ) else {
            return
        }
        
        vehicles.items[vehicleIndex].expenses.remove(at: expenseIndex)
        reloadExpenses()
    }
}
