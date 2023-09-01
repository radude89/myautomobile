//
//  EventsViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.07.2022.
//
import SwiftUI

final class EventsViewModel: ObservableObject {
    
    @ObservedObject var vehicles = Vehicles()
    
    var allEvents: [Event] {
        vehicles.items.flatMap { $0.events }
    }

    var hasEvents: Bool {
        !allEvents.isEmpty
    }
    
    func delete(atOffsets offsets: IndexSet) {
//        events.remove(atOffsets: offsets)
    }
    
}
