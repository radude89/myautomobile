//
//  ExpenseTrackingMoreItem.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

@MainActor
struct ExpenseTrackingMoreItem: View {
    private let vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
    
    var body: some View {
        NavigationLink("Expense tracking") {
            NavigationStack {
                expenseTrackingForm
            }
            .navigationTitle("Vehicles")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Private
private extension ExpenseTrackingMoreItem {
    var expenseTrackingForm: some View {
        Form {
            Section {
                if vehicles.items.count > 1 {
                    VehiclesSelectionView(vehicles: vehicles) { vehicle in
                        makeExpenseTrackingView(vehicle: vehicle)
                    }
                } else if let firstVehicle = vehicles.items.first {
                    makeExpenseTrackingView(vehicle: firstVehicle)
                } else {
                    Text("No vehicles")
                }
            } header: {
                Text("Select vehicle")
            }
        }
    }
    
    func makeExpenseTrackingView(vehicle: Vehicle) -> some View {
        ExpenseTrackingView(vehicle: vehicle)
            .navigationTitle("Expenses")
    }
}
