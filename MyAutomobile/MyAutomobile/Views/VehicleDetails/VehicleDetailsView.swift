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
    @State private var numberPlate = ""
    
    @State private var customFieldAlertIsPresented = false
    @State private var customFieldLabelText = ""
    @State private var customFieldValueText = ""
    @State private var selectedDate = Date()
    
    // installments -> different page. add installment should be in the different page.
    // ? events
    // 
    
    var body: some View {
        Form {
            Section {
                HStack {
                    VehicleImage(image: vehicle.icon)
                    TextField("Number Plate", text: $numberPlate)
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
                HStack {
                    Text("Colour")
                    Spacer()
                    Text("White")
                }
                Button("Add vehicle field") {
                    customFieldAlertIsPresented.toggle()
                }
                .alert("New vehicle info", isPresented: $customFieldAlertIsPresented) {
                    TextField("Name of field", text: $customFieldLabelText)
                    TextField("Value", text: $customFieldValueText)
                    Button("Save") {
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
            }
            
            Section {
                HStack {
                    Text("CASCO")
                    Spacer()
                    Text("12/12/2024")
                }
                Button("Add installment") {
                }
            } header: {
                Text("Recurrent events")
            } footer: {
                Text("Description about recurrent events (can be installments, etc).")
            }
            
            Section {
                HStack {
                    Text("ITP")
                    Spacer()
                    Text("02/10/2022")
                }
                HStack {
                    Text("Revizie auto")
                    Spacer()
                    Text("02/10/2022")
                }
                Button("Add event") {
                }
            } header: {
                Text("One-time events")
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
            numberPlate = vehicle.numberPlate
        }
    }
    
    private func clearCustomFieldValues() {
        customFieldLabelText = ""
        customFieldValueText = ""
    }
}

struct VehicleDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        VehicleDetailsView(vehicle: .constant(.demoVehicles.randomElement()!))
    }
}
