//
//  ExpenseTrackingMoreItem.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

@MainActor
struct ExpenseTrackingMoreItem: View {
    @StateObject private var viewModel: ExpenseTrackingMoreItemViewModel
    
    init(viewModel: ExpenseTrackingMoreItemViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationLink("Expense tracking") {
            expenseTrackingForm
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
                if viewModel.vehicles.items.count > 0 {
                    VehiclesSelectionView(
                        viewModel: .init(vehicles: viewModel.vehicles)
                    ) { vehicle in
                        ExpenseTrackingView(viewModel: .init(vehicle: vehicle))
                    }
                } else {
                    Text("No vehicles")
                }
            } header: {
                Text("Select vehicle")
            }
        }
    }
}
