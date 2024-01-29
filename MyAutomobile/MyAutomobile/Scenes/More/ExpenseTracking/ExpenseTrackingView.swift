//
//  ExpenseTrackingView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 29.01.2024.
//

import SwiftUI

struct ExpenseTrackingView: View {
    private let vehicle: Vehicle
    
    init(vehicle: Vehicle) {
        self.vehicle = vehicle
    }

    var body: some View {
        Text("Hello, World - \(vehicle.numberPlate)!")
    }
}

#Preview {
    ExpenseTrackingView(
        vehicle: .demoVehicles[0]
    )
}
