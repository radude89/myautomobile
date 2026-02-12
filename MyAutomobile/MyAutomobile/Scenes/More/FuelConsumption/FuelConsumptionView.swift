//
//  FuelConsumptionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI
import AccessibilityIdentifiers

struct FuelConsumptionView: View {
    @StateObject private var viewModel: FuelConsumptionViewModel
    @FocusState private var isInputActive: Bool
    
    init(viewModel: FuelConsumptionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationLink {
            Form {
                distanceSection
                fuelUsageSection
                fuelConsumptionSection
            }
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Fuel Calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
        } label: {
            Label("Fuel Calculator", systemImage: "fuelpump.fill")
        }
    }
}

// MARK: - Private
private extension FuelConsumptionView {
    typealias ViewModel = FuelConsumptionSectionViewModel
    
    var distanceSection: some View {
        FuelConsumptionSectionView(
            viewModel: $viewModel.distanceViewModel,
            isInputActive: _isInputActive
        )
    }
    
    var fuelUsageSection: some View {
        FuelConsumptionSectionView(
            viewModel: $viewModel.usageViewModel,
            isInputActive: _isInputActive
        )
    }
    
    var fuelConsumptionSection: some View {
        FuelConsumptionSectionView(
            viewModel: $viewModel.consumptionViewModel,
            isInputActive: _isInputActive
        )
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Calculate", action: calculateValues)
                .disabled(!viewModel.canCalculate)
                .accessibilityIdentifier(FuelCalculatorViewElements.CalculateButton.id)
        }
    }
    
    func calculateValues() {
        isInputActive = false
        viewModel.calculateValues()
    }
}
