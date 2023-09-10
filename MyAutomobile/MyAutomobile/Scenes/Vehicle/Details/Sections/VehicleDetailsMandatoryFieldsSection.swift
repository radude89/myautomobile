//
//  VehicleDetailsMandatoryFieldsSection.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.08.2023.
//

import SwiftUI

struct VehicleDetailsMandatoryFieldsSection: View {

    @Binding var makeText: String
    @Binding var modelText: String
    @Binding var vehicleColor: Color

    var body: some View {
        Section {
            TextField("Make", text: $makeText)
            TextField("Model", text: $modelText)
            ColorPicker("vehicle_color", selection: $vehicleColor)
                .frame(maxWidth: .infinity)
        } header: {
            Text("Vehicle information")
        } footer: {
            Text("footer_color")
        }
    }

}
