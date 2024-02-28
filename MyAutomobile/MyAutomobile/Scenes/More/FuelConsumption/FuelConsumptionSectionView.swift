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
                "\(viewModel.fieldPlaceholder) \(viewModel.currentUnit.description)",
                text: $viewModel.enteredAmount
            )
            .keyboardType(.decimalPad)
            
            Picker("Unit", selection: $viewModel.unitIndex) {
                ForEach(0 ..< viewModel.units.count, id: \.self) {
                    Text("\(viewModel.units[$0].description)")
                }
            }
        } header: {
            Text(viewModel.sectionTitle)
        }
    }
}

