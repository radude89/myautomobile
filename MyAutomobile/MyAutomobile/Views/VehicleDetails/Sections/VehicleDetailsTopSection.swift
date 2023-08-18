//
//  VehicleDetailsTopSection.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.08.2023.
//

import SwiftUI

struct VehicleDetailsTopSection: View {
    let vehicleColor: Color
    @Binding var numberPlateText: String
    
    var body: some View {
        Section {
            HStack {
                VehicleImage(color: vehicleColor)
                TextField("Number Plate", text: $numberPlateText)
                    .titleStyle
                    .padding(.leading)
            }
        }
    }
}
