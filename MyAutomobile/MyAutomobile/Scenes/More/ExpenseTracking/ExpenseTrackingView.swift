//
//  ExpenseTrackingView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

struct ExpenseTrackingView: View {
    private let viewModel: ExpenseTrackingViewModel
    @State private var showAddView = false
    
    init(viewModel: ExpenseTrackingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text("Hello, World - \(viewModel.vehicle.numberPlate)!")
            .sheet(isPresented: $showAddView) {
                ExpenseAddView()
            }
            .navigationTitle("Expenses")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    HStack {
                        Button(action: onAdd) {
                            Image(systemName: "plus")
                        }
                        if true {
                            EditButton()
                        }
                    }
                }
            }
    }
    
    private func onAdd() {
        showAddView.toggle()
    }
}
