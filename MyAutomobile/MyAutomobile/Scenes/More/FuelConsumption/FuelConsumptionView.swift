//
//  FuelConsumptionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI

struct FuelConsumptionView: View {
    @State private var distanceDetails = DistanceDetails(
        selectedDistanceIndex: 0,
        enteredDistance: ""
    )

    var body: some View {
        NavigationLink {
            Form {
                DistanceSection(distanceDetails: $distanceDetails)
            }
            .navigationTitle("Fuel Calculator")
            .navigationBarTitleDisplayMode(.inline)
        } label: {
            Label("Fuel Calculator", systemImage: "fuelpump.fill")
            
        }
    }
}
