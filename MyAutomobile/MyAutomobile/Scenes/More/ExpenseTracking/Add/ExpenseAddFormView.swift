//
//  ExpenseAddFormView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 01.02.2024.
//

import SwiftUI

struct ExpenseAddFormView: View {
    @Binding var expenseTypeIndex: Int
    @Binding var date: Date
    @Binding var odometerReading: String
    @Binding var cost: String
    @Binding var comment: String
    
    private let expenseTypes = ExpenseType.allCases
    
    var body: some View {
        Form {
            Section {
                DatePicker(
                    selection: $date,
                    displayedComponents: .date
                ) {
                    Text("Date")
                }
                
                TextField("Odometer reading (optional)", text: $odometerReading)
                    .keyboardType(.numberPad)
            } header: {
                Text("Enter the approximate reading")
            }

            Section {
                Picker("Expense type", selection: $expenseTypeIndex) {
                    ForEach(0 ..< expenseTypes.count, id: \.self) { index in
                        Text(expenseTypes[index].rawValue.capitalized)
                    }
                }
                
                TextField("Cost", text: $cost)
                    .keyboardType(.numberPad)
                
                TextField("Comment (optional)", text: $comment)
            } header: {
                Text("Enter your expense")
            }
        }
    }
}
