//
//  EventsViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.07.2022.
//
import SwiftUI

final class EventsViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    
    init(vehicles: Vehicles) {
        self.vehicles = vehicles
    }
    
    var allEvents: [Event] {
        vehicles.items
            .flatMap { $0.events }
            .sorted { $0.date < $1.date }
    }

    func events(for vehicle: Vehicle) -> [Event] {
        vehicle.events.sorted { $0.date < $1.date }
    }

    var hasEvents: Bool {
        !allEvents.isEmpty
    }
    
    func delete(atOffsets offsets: IndexSet) {
//        events.remove(atOffsets: offsets)
    }
    
}
