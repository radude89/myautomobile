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
    
    init(vehicles: Vehicles, vehicleID: UUID) {
        self.vehicles = vehicles
        self.vehicleID = vehicleID
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
        vehicle?.expenses.sorted { $0.date > $1.date } ?? []
    }
    
    func deleteExpense(at indexSet: IndexSet) {
        guard let vehicle else {
            return
        }
        
        var copyVehicle = vehicle
        var sortedExpenses = copyVehicle.expenses.sorted { $0.date > $1.date }
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
