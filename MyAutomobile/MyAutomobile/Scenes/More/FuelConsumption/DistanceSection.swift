//
//  DistanceSection.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.02.2024.
//

import SwiftUI

struct DistanceDetails {
    var selectedDistanceIndex: Int
    var enteredDistance: String
}

struct DistanceSection: View {
    private let distanceUnits = [
        "km": 1,
        "miles": 0.621371
    ]
    
    private var distanceUnitsKeys: [String] {
        distanceUnits.keys.sorted()
    }
    
    private var currentUnit: String {
        distanceUnitsKeys[distanceDetails.selectedDistanceIndex]
    }
    
    @Binding var distanceDetails: DistanceDetails

    var body: some View {
        Section {
            TextField(
                "Enter your travel distance in \(currentUnit)",
                text: $distanceDetails.enteredDistance
            )
            .keyboardType(.decimalPad)
            
            Picker("Selected unit", selection: $distanceDetails.selectedDistanceIndex) {
                ForEach(0 ..< distanceUnitsKeys.count, id: \.self) {
                    Text("\(distanceUnitsKeys[$0])")
                }
            }
        } header: {
            Text("Travel distance")
        }
    }
}
