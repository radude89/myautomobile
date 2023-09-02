//
//  EventAddView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventAddView: View {

    @StateObject private var viewModel: EventAddViewModel
    
    @State private var titleText = ""
    @State private var recurrence = 0
    @State private var date: Date = .now
    @State private var selectedVehicleIndex = 0
    
    init(viewModel: EventAddViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Description", text: $titleText)
            } header: {
                Text("Enter description")
            }
            
            Section {
                Picker("Cars", selection: $selectedVehicleIndex) {
                    ForEach(viewModel.items.indices, id: \.self) { index in
                        Text(viewModel.items[index].numberPlate)
                    }
                }
            } header: {
                Text("Select your car")
            }
            
            Section {
                DatePicker(
                    selection: $date,
                    displayedComponents: .date
                ) {
                    Text("Date")
                }
                
                Picker("Recurrence", selection: $recurrence) {
                    ForEach(0..<Event.Recurrence.allCases.count, id: \.self) { index in
                        Text(Event.Recurrence.allCases[index].rawValue)
                    }
                }
            } header: {
                Text("Select date")
            }
        }
    }
}

struct EventAddView_Previews: PreviewProvider {
    static var previews: some View {
        EventAddView(viewModel: .init(vehicles: .init()))
    }
}
