//
//  VehicleListViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import SwiftUI
import EventKit

final class VehicleListViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    private let eventStoreManager: EventStoreManager
    
    init(vehicles: Vehicles, eventStoreManager: EventStoreManager) {
        self.vehicles = vehicles
        self.eventStoreManager = eventStoreManager
    }
    
    var hasVehicles: Bool {
        !vehicles.items.isEmpty
    }
    
    func delete(atOffsets offsets: IndexSet) async {
        if let firstIndex = offsets.first {
            let vehicle = vehicles.items[firstIndex]
            await deleteEKEvents(for: vehicle)
        }
        vehicles.items.remove(atOffsets: offsets)
        objectWillChange.send()
    }
    
    private func deleteEKEvents(for vehicle: Vehicle) async {
        let eventIDs = vehicle.events.compactMap { $0.localCalendarID }
        do {
            try await eventStoreManager.removeEvents(withIDs: eventIDs)
        } catch {
            print(error)
        }
    }
    
}