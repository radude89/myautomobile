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
    
    @Environment(\.presentationMode) private var presentationMode
    
    @StateObject private var viewModel: ExpenseTrackingViewModel
    
    init(viewModel: ExpenseTrackingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, World - \(viewModel.vehicle.numberPlate)!")
            .sheet(isPresented: $showAddView) {
                ExpenseAddView()
            }
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
    func onAdd() {
        showAddView = true
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            HStack {
                Button(action: onAdd) {
                    Image(systemName: "plus")
                }
                if viewModel.shouldDisplayEdit {
                    EditButton()
                }
            }
        }
    }
}
