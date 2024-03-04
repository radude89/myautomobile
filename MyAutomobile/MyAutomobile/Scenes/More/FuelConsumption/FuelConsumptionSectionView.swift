//
//  FuelConsumptionSectionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.02.2024.
//

import SwiftUI

struct FuelConsumptionSectionView: View {
    @Binding var viewModel: FuelConsumptionSectionViewModel
    
    init(viewModel: Binding<FuelConsumptionSectionViewModel>) {
        _viewModel = viewModel
    }
    
    var body: some View {
        Section {
            TextField(
                String(localized: .init(viewModel.fieldPlaceholder)),
                text: $viewModel.enteredAmount
            )
            .keyboardType(.decimalPad)
            
            Picker("Unit", selection: $viewModel.unitIndex) {
                ForEach(0 ..< viewModel.units.count, id: \.self) { unitIndex in
                    Text(String(localized: .init(viewModel.units[unitIndex].measure)))
                }
            }
        } header: {
            Text(
                String(localized: .init(viewModel.sectionTitle))
            )
        }
    }
}

