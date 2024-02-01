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
        guard !viewModel.items.isEmpty,
              let firstVehicle = viewModel.firstVehicle else {
            return AnyView(emptyView)
        }
        
        return if viewModel.items.count > 1 {
            AnyView(selectionView)
        } else {
            AnyView(
                ExpenseTrackingView(vehicle: firstVehicle)
            )
        }
    }
    
    var emptyView: some View {
        Text("expenses_empty")
            .font(.body)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing])
    }
    
    var selectionView: some View {
        Form {
            Section {
                VehiclesSelectionView(
                    viewModel: .init(vehicles: viewModel.vehicles)
                ) { vehicle in
                    ExpenseTrackingView(vehicle: vehicle)
                }
            } header: {
                Text("Select vehicle")
            }
        }
    }
}
