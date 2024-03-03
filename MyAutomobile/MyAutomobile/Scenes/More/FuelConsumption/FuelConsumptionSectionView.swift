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
                textFieldLocalizedText,
                text: $viewModel.enteredAmount
            )
            .keyboardType(.decimalPad)
            
            Picker("Unit", selection: $viewModel.unitIndex) {
                ForEach(0 ..< viewModel.units.count, id: \.self) {
                    Text(String(localized: "\(viewModel.units[$0].description)"))
                }
            }
        } header: {
            Text(viewModel.sectionTitle)
        }
    }
    
    private var textFieldLocalizedText: String {
        let localizedPlaceholder = String(localized: .init(viewModel.fieldPlaceholder))
        let localizedUnit = String(localized: .init(viewModel.currentUnit.description))
        return "\(localizedPlaceholder) \(localizedUnit)"
    }
}

