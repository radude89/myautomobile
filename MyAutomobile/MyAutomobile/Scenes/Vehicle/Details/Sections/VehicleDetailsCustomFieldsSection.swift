//
//  VehicleDetailsCustomFieldsSection.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.08.2023.
//

import SwiftUI
import AccessibilityIdentifiers

struct VehicleDetailsCustomFieldsSection: View {

    @State private var alertIsPresented = false
    @State private var labelText = ""
    @State private var valueText = ""
        
    let customFields: [String: Vehicle.FieldDetails]
    let onSave: (_ key: String, _ value: String) -> ()
    let onDelete: (IndexSet) -> ()
    
    var body: some View {
        Section {
            ForEach(sortedValues, id: \.key) { key, value in
                if let fieldDetails = customFields[key] {
                    HStack {
                        Text(fieldDetails.key)
                        Spacer()
                        Text(fieldDetails.value)
                    }
                }
            }
            .onDelete(perform: onDelete)

            Button("Add vehicle field") {
                alertIsPresented.toggle()
            }
            .accessibilityIdentifier(
                AccessibilityIdentifiers.VehicleDetailViewElements.AddFieldButton.id
            )
            .sheet(isPresented: $alertIsPresented) {
                NavigationStack {
                    VehicleAddCustomFieldView(onDone: onSave)
                }
            }
        } header: {
            Text("Additional information")
        } footer: {
            Text("footer_additional_info")
        }
    }

}

private extension VehicleDetailsCustomFieldsSection {
    var sortedValues: [(key: String, value: Vehicle.FieldDetails)] {
        customFields.sorted(by: >)
    }

    func clearCustomFieldValues() {
        labelText = ""
        valueText = ""
    }
}
