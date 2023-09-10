//
//  EventAddFormView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventAddFormView: View {
    
    @Binding var selectedVehicleIndex: Int
    @Binding var recurrenceIndex: Int
    @Binding var date: Date
    @Binding var titleText: String
    @Binding var addEventToLocalCalendar: Bool
    
    let vehicles: [Vehicle]
    
    var body: some View {
        Form {
            Section {
                TextField("Description", text: $titleText)
            } header: {
                Text("Enter description")
            }
            
            Section {
                Picker("Vehicle", selection: $selectedVehicleIndex) {
                    ForEach(vehicles.indices, id: \.self) { index in
                        Text(vehicles[index].numberPlate)
                    }
                }
            } header: {
                Text("Select your vehicle")
            }
            
            Section {
                DatePicker(
                    selection: $date,
                    displayedComponents: .date
                ) {
                    Text("Date")
                }
                
                Picker("Recurrence", selection: $recurrenceIndex) {
                    ForEach(0..<Event.Recurrence.allCases.count, id: \.self) { index in
                        Text(Event.Recurrence.allCases[index].localizedKey)
                    }
                }
            } header: {
                Text("Select date")
            }
            
            Section {
                Toggle(isOn: $addEventToLocalCalendar) {
                    Text("Add to your local calendar")
                }
            }
        }
    }
    
}
