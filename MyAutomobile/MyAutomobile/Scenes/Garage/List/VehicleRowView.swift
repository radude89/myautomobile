//
//  VehicleRowView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import SwiftUI

struct VehicleRowView: View {
    let vehicle: Vehicle
    
    var body: some View {
        HStack {
            VehicleImage(color: vehicle.color)

            VStack(alignment: .leading) {
                Text(vehicle.numberPlate)
                    .titleStyle
                
                Text("\(vehicle.make) \(vehicle.model)")
                    .font(.subheadline)
            }
        }
    }
}
