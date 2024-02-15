//
//  FuelConsumptionSectionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.02.2024.
//

import SwiftUI

struct FuelConsumptionSectionView: View {
    private let units: [String: Double]
    private let fieldPlaceholder: String
    private let sectionTitle: String
    
    private var keys: [String] {
        units.keys.sorted()
    }
    
    private var currentUnit: String {
        keys[details.unitIndex]
    }
    
    @Binding var details: FuelConsumptionDetails
    
    init(units: [String : Double],
         fieldPlaceholder: String,
         sectionTitle: String,
         details: Binding<FuelConsumptionDetails>) {
        self.units = units
        self.fieldPlaceholder = fieldPlaceholder
        self.sectionTitle = sectionTitle
        _details = details
    }
    
    var body: some View {
        Section {
            TextField(
                "\(fieldPlaceholder) \(currentUnit)",
                text: $details.enteredAmount
            )
            .keyboardType(.decimalPad)
            
            Picker("Unit", selection: $details.unitIndex) {
                ForEach(0 ..< keys.count, id: \.self) {
                    Text("\(keys[$0])")
                }
            }
        } header: {
            Text(sectionTitle)
        }
    }
}

