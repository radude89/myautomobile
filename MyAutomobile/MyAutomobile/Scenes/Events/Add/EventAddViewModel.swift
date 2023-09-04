//
//  EventAddViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

final class EventAddViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
    
    var items: [Vehicle] {
        vehicles.items
    }
    
    func saveEvent(
        date: Date,
        titleText: String,
        recurrenceIndex: Int,
        vehicleIndex: Int
    ) {
        let event = Event(date: date, description: titleText, recurrence: Event.Recurrence.allCases[recurrenceIndex])
        vehicles.items[vehicleIndex].events.append(event)
    }
    
}
