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
    let showSyncWithLocalCalendarSection: Bool

    private let recurrences = Event.Recurrence.allCases
    
    var body: some View {
        Form {
            descriptionSection
            selectVehicleSection
            dateSection
            if showSyncWithLocalCalendarSection {
                addEventToggleSection
            }
        }
    }
}

// MARK: - Private
private extension EventAddFormView {
    var descriptionSection: some View {
        Section {
            TextField("Description", text: $titleText)
        } header: {
            Text("Enter description")
        }
    }

    var selectVehicleSection: some View {
        Section {
            Picker("Vehicle", selection: $selectedVehicleIndex) {
                ForEach(vehicles.indices, id: \.self) { index in
                    Text(vehicles[index].numberPlate)
                }
            }
        } header: {
            Text("Select your vehicle")
        }
    }

    var dateSection: some View {
        Section {
            DatePicker(
                selection: $date,
                displayedComponents: .date
            ) {
                Text("Date")
            }
            
            Picker("Recurrence", selection: $recurrenceIndex) {
                ForEach(0..<recurrences.count, id: \.self) { index in
                    Text(recurrences[index].localizedKey)
                }
            }
        } header: {
            Text("Select date")
        }
    }

    var addEventToggleSection: some View {
        Section {
            Toggle(isOn: $addEventToLocalCalendar) {
                Text("Add to your local calendar")
            }
        }
    }
}
