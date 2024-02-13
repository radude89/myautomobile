//
//  FuelConsumptionView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 13.02.2024.
//

import SwiftUI

struct FuelConsumptionView: View {
    var body: some View {
        NavigationLink {
            Text("Hello, World!")
                .navigationTitle("Fuel Calculator")
                .navigationBarTitleDisplayMode(.inline)
        } label: {
            Label("Fuel Calculator", systemImage: "fuelpump.fill")
            
        }
    }
}
