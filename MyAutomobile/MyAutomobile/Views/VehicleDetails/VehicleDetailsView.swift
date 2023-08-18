//
//  VehicleDetailsView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 12.07.2022.
//

import SwiftUI

struct VehicleDetailsView: View {
    
    @Environment(\.editMode) private var editMode
    
    @State var vehicle: Vehicle
    
    @State private var make = ""
    @State private var model = ""
    @State private var numberPlate = ""
    
    @State private var vehicleColor = Color.red

    @State private var customFieldAlertIsPresented = false
    @State private var customFieldLabelText = ""
    @State private var customFieldValueText = ""
    
    var body: some View {
        Form {
            Section {
                HStack {
                    VehicleImage(color: vehicle.color)
                    TextField("Number Plate", text: $numberPlate)
                        .titleStyle
                        .padding(.leading)
                }
            }
            Section {
                TextField("Make", text: $make)
                TextField("Model", text: $model)
                HStack {
                    ColorPicker("Vehicle's color", selection: $vehicleColor)
                        .frame(maxWidth: .infinity)
                }
            } header: {
                Text("Vehicle information")
            } footer: {
                Text("These are your key details for your vehicle. You can edit them by diretly tapping on a row.\nTo pick a color you need to tap on the right circle of \"Vehicle's color\" row.")
            }
            
            Section {
                ForEach(Array(vehicle.customFields.keys), id: \.self) { key in
                    if let fieldDetails = vehicle.customFields[key] {
                        HStack {
                            Text(fieldDetails.key)
                            Spacer()
                            Text(fieldDetails.value)
                        }
                    }
                }
                .onDelete { _ in
                    print("Delete")
                }
                Button("Add vehicle field") {
                    customFieldAlertIsPresented.toggle()
                }
                .alert("New vehicle info", isPresented: $customFieldAlertIsPresented) {
                    TextField("Name of field", text: $customFieldLabelText)
                    TextField("Value", text: $customFieldValueText)
                    Button("Save") {
                        saveDetails()
                        clearCustomFieldValues()
                    }
                    Button("Cancel", role: .cancel) {
                        clearCustomFieldValues()
                    }
                } message: {
                    Text("Please enter your new vehicle details")
                }
            } header: {
                Text("Additional information")
            } footer: {
                Text("Here you can find your optional vehicle details. You can add or delete key-value properties for your vehicle.\nFor example, you can enter the field name \"Vehicle age\" with the value \"5 years\".")
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Details")
        .onAppear {
            make = vehicle.make
            model = vehicle.model
            numberPlate = vehicle.numberPlate
            vehicleColor = vehicle.color
        }
        .onDisappear {
            // TODO: Save here details
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
    }
    
    private func saveDetails() {
        guard !customFieldLabelText.isEmpty && !customFieldValueText.isEmpty else {
            return
        }

        let newKey = UUID().uuidString
        vehicle.customFields[newKey] = Vehicle.FieldDetails(key: customFieldLabelText, value: customFieldValueText)
    }
    
    private func clearCustomFieldValues() {
        customFieldLabelText = ""
        customFieldValueText = ""
    }
}

struct VehicleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailsView(vehicle: .demoVehicles.randomElement()!)
    }
}
