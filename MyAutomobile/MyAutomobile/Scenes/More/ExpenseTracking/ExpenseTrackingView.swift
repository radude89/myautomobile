//
//  ExpenseTrackingView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

struct ExpenseTrackingView: View {
    @State private var showAddView = false
    @State private var showInfoAlert = false
    @StateObject private var viewModel: ExpenseTrackingViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    init(viewModel: ExpenseTrackingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, World - \(viewModel.vehicleID)!")
            .sheet(isPresented: $showAddView) { addView }
            .navigationTitle("Expenses")
            .toolbar { toolbar }
            .alert("Warning", isPresented: $showInfoAlert) {
                Button("OK", role: .cancel) {
                    showInfoAlert = false
                    presentationMode.wrappedValue.dismiss()
                }
            } message: {
                Text("It looks like this vehicle has been deleted")
            }
            .onAppear {
                if viewModel.hasDeletedVehicle {
                    showInfoAlert = true
                }
            }
    }
}

// MARK: - Private
private extension ExpenseTrackingView {
    var addView: some View {
        ExpenseAddView(
            viewModel: .init(
                vehicles: viewModel.vehicles,
                vehicleID: viewModel.vehicleID
            )
        )
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.shouldDisplayEdit {
                EditButton()
            }
        }
        ToolbarItem {
            Button(action: onAdd) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    func onAdd() {
        showAddView = true
    }
}
