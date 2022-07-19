//
//  VehicleDetailsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.07.2022.
//

import SwiftUI

struct VehicleDetailsView: View {
    
    @Binding var vehicle: Vehicle
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var make = ""
    @State private var model = ""
    
    var body: some View {
        Form {
            Section {
                HStack {
                    VehicleImage(image: vehicle.icon)
                    Text(vehicle.numberPlate)
                        .titleStyle
                        .padding(.leading)
                }
            }
            Section {
                TextField("Make", text: $make)
                TextField("Model", text: $model)
            } header: {
                Text("Vehicle information")
            }
            
            Section {
                Button("Save Details") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
        .onAppear {
            make = vehicle.make
            model = vehicle.model
        }
    }
}

struct VehicleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailsView(vehicle: .constant(.demoVehicles.randomElement()!))
    }
}
