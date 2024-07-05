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
    @State private var viewOption: ViewOption = .list
    @State private var isEditing = false
    
    private enum ViewOption: String, CaseIterable {
        case list = "List"
        case chart = "Chart"
        
        var localizedName: String {
            String(localized: .init(rawValue))
        }
    }
    
    @StateObject private var viewModel: ExpenseTrackingViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.editMode) private var editMode
    
    init(viewModel: ExpenseTrackingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        contentView
            .sheet(isPresented: $showAddView) { addView }
            .navigationTitle("Expenses")
            .toolbar { toolbar }
            .environment(\.editMode, .constant(isEditing ? .active : .inactive))
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
    @ViewBuilder
    var contentView: some View {
        if viewModel.expenses.isEmpty {
            emptyView
        } else {
            mainView
        }
    }
    
    var mainView: some View {
        VStack {
            if !viewModel.showOnlyMaintenanceItems {
                selectionView
            }
            
            Text("Total: \(viewModel.formattedTotalCost)")
                .titleStyle
            
            if viewOption == .list {
                listContentView
            } else {
                ExpenseChartView(
                    expenseData: ExpenseChartDataMapper.map(expenses: viewModel.expenses)
                )
            }
        }
    }
    
    var selectionView: some View {
        Picker("View", selection: $viewOption) {
            ForEach(ViewOption.allCases, id: \.self) {
                Text($0.localizedName)
            }
        }
        .background(Color.clear)
        .pickerStyle(.segmented)
        .padding()
    }
    
    var emptyView: some View {
        Text("expenses_empty")
            .font(.body)
            .multilineTextAlignment(.center)
            .padding([.leading, .trailing], 32)
    }
    
    var listContentView: some View {
        List {
            Section {
                ForEach(viewModel.expenses) { expense in
                    ExpenseRowView(viewModel: .init(expense: expense))
                }
                .onDelete { indexSet in
                    viewModel.deleteExpense(at: indexSet)
                    Task { @MainActor in
                        if viewModel.expenses.isEmpty {
                            isEditing = false
                        }
                    }
                }
            } header: {
                Text("List of expenses")
            }
        }
    }

    var addView: some View {
        ExpenseAddView(
            viewModel: .init(
                vehicles: viewModel.vehicles,
                vehicleID: viewModel.vehicleID,
                showOnlyMaintenanceItems: viewModel.showOnlyMaintenanceItems
            )
        ) {
            Task { @MainActor in
                viewModel.reloadExpenses()
                isEditing = false
            }
        }
    }

    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button {
                withAnimation {
                    isEditing.toggle()
                }
            } label: {
                Text(isEditing ? "Done" : "Edit")
            }
            .disabled(viewModel.expenses.isEmpty)
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
