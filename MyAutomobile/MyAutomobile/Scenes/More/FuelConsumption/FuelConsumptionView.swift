//
//  FuelConsumptionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI

struct FuelConsumptionView: View {
    @StateObject private var viewModel: FuelConsumptionViewModel
    
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
        FuelConsumptionSectionView(viewModel: $viewModel.distanceViewModel)
    }
    
    var fuelUsageSection: some View {
        FuelConsumptionSectionView(viewModel: $viewModel.usageViewModel)
    }
    
    var fuelConsumptionSection: some View {
        FuelConsumptionSectionView(viewModel: $viewModel.consumptionViewModel)
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Calculate", action: calculateValues)
                .disabled(!viewModel.canCalculate)
        }
    }
    
    func calculateValues() {
        viewModel.calculateValues()
    }
}
