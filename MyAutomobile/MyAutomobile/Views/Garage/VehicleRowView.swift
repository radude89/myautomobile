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
            VehicleImage(image: vehicle.icon)
                .padding([.top, .bottom])
            
            VStack(alignment: .leading) {
                Text(vehicle.numberPlate)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                
                Text("\(vehicle.make) \(vehicle.model)")
            }
            .padding()
        }
    }
}

// MARK: - Previews

struct VehicleRowView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleRowView(vehicle: .demoVehicles.randomElement()!)
    }
}
