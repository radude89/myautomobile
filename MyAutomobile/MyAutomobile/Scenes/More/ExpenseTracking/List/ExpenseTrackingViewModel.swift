//
//  ExpenseTrackingViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

final class ExpenseTrackingViewModel: ObservableObject {
    @ObservedObject var vehicles: Vehicles
    let vehicleID: UUID
    let showOnlyMaintenanceItems: Bool
    
    init(vehicles: Vehicles, 
         vehicleID: UUID,
         showOnlyMaintenanceItems: Bool = false) {
        self.vehicles = vehicles
        self.vehicleID = vehicleID
        self.showOnlyMaintenanceItems = showOnlyMaintenanceItems
    }
    
    var shouldDisplayEdit: Bool {
        guard let vehicle else {
            return false
        }

        return !vehicle.expenses.isEmpty
    }
    
    var hasDeletedVehicle: Bool {
        vehicle == nil
    }
    
    var expenses: [Expense] {
        if !showOnlyMaintenanceItems {
            vehicle?.expenses.sorted { $0.date > $1.date } ?? []
        } else {
            vehicle?.expenses
                .filter { $0.expenseType == .maintenance }
                .sorted { $0.date > $1.date } ?? []
        }
    }
    
    var formattedTotalCost: String {
        let formatter = NumberFormatterFactory.makeAmountFormatter()
        let total = expenses.reduce(0.0) { $0 + $1.cost }
        return formatter.string(from: NSNumber(value: total)) ?? "0"
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        guard let vehicle else {
            return
        }
        
        var copyVehicle = vehicle
        var sortedExpenses = copyVehicle.expenses.sorted { $0.date > $1.date }
        if showOnlyMaintenanceItems {
            sortedExpenses = sortedExpenses.filter { $0.expenseType == .maintenance }
        }
        sortedExpenses.remove(atOffsets: indexSet)
        copyVehicle.expenses = sortedExpenses
        updateVehicles(vehicle: copyVehicle)
    }
}

// MARK: - Private
private extension ExpenseTrackingViewModel {
    var vehicle: Vehicle? {
        vehicles.items.first { $0.id == vehicleID }
    }
    
    func updateVehicles(vehicle: Vehicle) {
        var items = vehicles.items
        items.removeAll { $0.id == vehicle.id }
        items.append(vehicle)
        vehicles.items = items.sorted { $0.dateCreated < $1.dateCreated }
    }
}
