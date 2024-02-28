//
//  FuelConsumptionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI

struct FuelConsumptionView: View {
    @State private var distanceViewModel: FuelConsumptionSectionViewModel = .distance
    @State private var usageViewModel: FuelConsumptionSectionViewModel = .usage
    @State private var consumptionViewModel: FuelConsumptionSectionViewModel = .consumption
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 2
        return formatter
    }()

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
        FuelConsumptionSectionView(viewModel: $distanceViewModel)
    }
    
    var fuelUsageSection: some View {
        FuelConsumptionSectionView(viewModel: $usageViewModel)
    }
    
    var fuelConsumptionSection: some View {
        FuelConsumptionSectionView(viewModel: $consumptionViewModel)
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Calculate", action: calculateValues)
                .disabled(!canCalculate)
        }
    }
    
    func calculateValues() {
        
        if let distanceInKm = numberFormatter
            .number(from: distanceViewModel.enteredAmount)?
            .doubleValue
            .toKm(from: distanceViewModel.currentUnit),
            distanceInKm > 0 {
            if let fuelUsageInLiters = numberFormatter
                .number(from: usageViewModel.enteredAmount)?
                .doubleValue
                .toLiters(from: usageViewModel.currentUnit) {
                let consumption = FieldCalculator.calculateConsumption(
                    distanceInKm: distanceInKm,
                    usageInLiters: fuelUsageInLiters,
                    unit: consumptionViewModel.currentUnit
                )
                consumptionViewModel.enteredAmount = numberFormatter.string(
                    from: NSNumber(value: consumption)
                ) ?? ""
            } else if let consumption = numberFormatter
                .number(from: consumptionViewModel.enteredAmount)?
                .doubleValue {
                let consumptionInLitersPerKm = UnitConverter.convertToLitersPerKm(
                    consumption,
                    from: consumptionViewModel.currentUnit
                )
                let usage = FieldCalculator.calculateUsage(
                    distanceInKm: distanceInKm,
                    consumptionInLitersPerKm: consumptionInLitersPerKm,
                    unit: usageViewModel.currentUnit
                )
                usageViewModel.enteredAmount = numberFormatter.string(
                    from: NSNumber(value: usage)
                ) ?? ""
            }
        } else if let fuelUsageInLiters = numberFormatter
            .number(from: usageViewModel.enteredAmount)?
            .doubleValue
            .toLiters(from: usageViewModel.currentUnit) {
            if let consumption = numberFormatter
                .number(from: consumptionViewModel.enteredAmount)?
                .doubleValue,
               consumption > 0  {
                let consumptionInLitersPerKm = UnitConverter.convertToLitersPerKm(
                    consumption,
                    from: consumptionViewModel.currentUnit
                )
                let distance = FieldCalculator.calculateDistance(
                    usageInLiters: fuelUsageInLiters,
                    consumptionInLitersPerKm: consumptionInLitersPerKm,
                    unit: distanceViewModel.currentUnit
                )
                distanceViewModel.enteredAmount = numberFormatter.string(
                    from: NSNumber(value: distance)
                ) ?? ""
            }
        }
    }
    
    var canCalculate: Bool {
        let distance = numberFormatter.number(from: distanceViewModel.enteredAmount)?.doubleValue
        let fuelUsage = numberFormatter.number(from: usageViewModel.enteredAmount)?.doubleValue
        let consumption = numberFormatter.number(from: consumptionViewModel.enteredAmount)?.doubleValue
        
        if distance == nil {
            return fuelUsage != nil && consumption != nil
        }
        
        if fuelUsage == nil {
            return distance != nil && consumption != nil
        }
        
        if consumption == nil {
            return distance != nil && fuelUsage != nil
        }
        
        return true
    }
}
