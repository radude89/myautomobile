//
//  ExpenseAddView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

struct ExpenseAddView: View {
    @State private var expenseTypeIndex = 3
    @State private var date: Date = .now
    @State private var odometerReading = ""
    @State private var cost = ""
    @State private var comment = ""
    
    @StateObject private var viewModel: ExpenseAddViewModel
    @Environment(\.presentationMode) private var presentationMode
    
    private let onSave: () -> Void
    
    init(
        viewModel: ExpenseAddViewModel,
        onSave: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationBarTitle("Add your expense")
                .addToolbar(
                    isDoneButtonDisabled: doneButtonIsDisabled,
                    hasChanges: hasChanges,
                    confirmationTitle: "alert_confirmation_expense_discard_title",
                    onDone: saveExpense
                )
                .interactiveDismissDisabled(hasChanges)
                .scrollDismissesKeyboard(.interactively)
                .onAppear {
                    expenseTypeIndex = viewModel.initialExpenseTypeIndex
                }
        }
    }
}

// MARK: - Private
private extension ExpenseAddView {
    var contentView: some View {
        ExpenseAddFormView(
            expenseTypeIndex: $expenseTypeIndex,
            showOnlyMaintenanceItems: viewModel.showOnlyMaintenanceItems,
            date: $date,
            odometerReading: $odometerReading,
            cost: $cost,
            comment: $comment,
            expenseTypes: viewModel.expenseTypes
        )
    }
    
    var doneButtonIsDisabled: Bool {
        cost.isEmpty
    }
    
    var hasChanges: Bool {
        !odometerReading.isEmpty || !cost.isEmpty || !comment.isEmpty
    }
    
    func saveExpense() {
        viewModel.saveExpense(
            expenseTypeIndex: expenseTypeIndex,
            date: date,
            odometerReadingDescription: odometerReading,
            costDescription: cost,
            commentDescription: comment
        )
        onSave()
        presentationMode.wrappedValue.dismiss()
    }
}
