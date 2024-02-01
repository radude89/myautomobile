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
    
    @Environment(\.presentationMode) private var presentationMode
    
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
        }
    }
}

// MARK: - Private
private extension ExpenseAddView {
    var contentView: some View {
        ExpenseAddFormView(
            expenseTypeIndex: $expenseTypeIndex,
            date: $date,
            odometerReading: $odometerReading,
            cost: $cost,
            comment: $comment
        )
    }
    
    var doneButtonIsDisabled: Bool {
        cost.isEmpty
    }
    
    var hasChanges: Bool {
        !odometerReading.isEmpty || !cost.isEmpty || !comment.isEmpty
    }
    
    func saveExpense() {
        presentationMode.wrappedValue.dismiss()
    }
}
