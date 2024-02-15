//
//  FuelConsumptionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI

struct FuelConsumptionView: View {
    @State private var distanceDetails = FuelConsumptionDetails()
    @State private var usageDetails = FuelConsumptionDetails(unitIndex: 2)
    @State private var consumptionDetails = FuelConsumptionDetails()

    var body: some View {
        NavigationLink {
            Form {
                distanceSection
                fuelUsageSection
                fuelConsumptionSection
            }
            .navigationTitle("Fuel Calculator")
            .navigationBarTitleDisplayMode(.inline)
        } label: {
            Label("Fuel Calculator", systemImage: "fuelpump.fill")
            
        }
    }
}

// MARK: - Private
private extension FuelConsumptionView {
    var distanceSection: some View {
        FuelConsumptionSectionView(
            units: [
                "km": 1,
                "miles": 0.621371
            ],
            fieldPlaceholder: "Enter your travel distance in",
            sectionTitle: "Travel distance",
            details: $distanceDetails
        )
    }
    
    var fuelUsageSection: some View {
        FuelConsumptionSectionView(
            units: [
                "liters": 1,
                "US gallons": 0.26417,
                "UK gallons": 0.21997
            ],
            fieldPlaceholder: "Enter your fuel usage in",
            sectionTitle: "Fuel usage",
            details: $usageDetails
        )
    }
    
    var fuelConsumptionSection: some View {
        FuelConsumptionSectionView(
            units: [
                "L/km": 1,
                "L/10 km": 10,
                "L/100 km": 100,
                "US gal/mi": 0.42514,
                "UK gal/mi": 0.354
            ],
            fieldPlaceholder: "Enter your fuel consumption in",
            sectionTitle: "Fuel consumption",
            details: $consumptionDetails
        )
    }
}
