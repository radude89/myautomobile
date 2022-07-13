//
//  VehicleDetailsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.07.2022.
//

import SwiftUI

struct VehicleDetailsView: View {
    
    @Binding var vehicle: Vehicle
    
    var body: some View {
        Text(vehicle.numberPlate)
    }
}

struct VehicleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailsView(vehicle: .constant(.demoVehicles.randomElement()!))
    }
}
