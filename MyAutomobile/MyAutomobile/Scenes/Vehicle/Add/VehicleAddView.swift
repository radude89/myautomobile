//
//  VehicleAddView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.08.2023.
//

import SwiftUI

struct VehicleAddView: View {
    
    @StateObject private var viewModel: VehicleAddViewModel
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var makeText = ""
    @State private var modelText = ""
    @State private var numberPlateText = ""
    @State private var color = Color.green
    
    init(viewModel: VehicleAddViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationBarTitle("Add your new vehicle")
                .addToolbar(
                    isDoneButtonDisabled: doneButtonIsDisabled,
                    hasChanges: hasChanges,
                    confirmationTitle: "alert_confirmation_vehicle_discard_title",
                    onDone: saveVehicle
                )
                .interactiveDismissDisabled(hasChanges)
        }
    }
}

// MARK: - Private methods
private extension VehicleAddView {
    @ViewBuilder
    var contentView: some View {
        Form {
            Section {
                TextField("Number Plate", text: $numberPlateText)
                TextField("Make", text: $makeText)
                TextField("Model", text: $modelText)
            } header: {
                Text("Information")
            }
            
            Section {
                HStack {
                    ColorPicker("vehicle_color", selection: $color)
                        .frame(maxWidth: .infinity)
                }
            } header: {
                Text("Color")
            }
        }
    }
    
    var doneButtonIsDisabled: Bool {
        makeText.isEmpty || modelText.isEmpty || numberPlateText.isEmpty
    }
    
    var hasChanges: Bool {
        !makeText.isEmpty || !modelText.isEmpty || !numberPlateText.isEmpty
    }
    
    func saveVehicle() {
        viewModel.saveVehicle(
            numberPlate: numberPlateText,
            makeText: makeText,
            modelText: modelText,
            color: color
        )
        presentationMode.wrappedValue.dismiss()
    }
}
