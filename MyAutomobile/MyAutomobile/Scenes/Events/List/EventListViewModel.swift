//
//  EventListViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 18.07.2022.
//
import SwiftUI
import EventKit

@MainActor
final class EventListViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles
    
    private(set) var eventStoreManager: EventStoreManager
    
    init(vehicles: Vehicles, eventStoreManager: EventStoreManager) {
        self.vehicles = vehicles
        self.eventStoreManager = eventStoreManager
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
    
    var hasVehicles: Bool {
        !vehicles.items.isEmpty
    }
    
    func deleteEvent(at indexSet: IndexSet) {
        guard let vehicle = vehicles.items.first else {
            return
        }
        
        deleteEvent(forVehicle: vehicle, at: indexSet)
        deleteEKEvents(vehicle: vehicle, at: indexSet)
    }
    
    func deleteEvent(forVehicle vehicle: Vehicle, at indexSet: IndexSet) {
        var copyVehicle = vehicle
        copyVehicle.events.remove(atOffsets: indexSet)
        updateVehicles(vehicle: copyVehicle)
    }
    
    private func updateVehicles(vehicle: Vehicle) {
        var items = vehicles.items
        items.removeAll { $0.id == vehicle.id }
        items.append(vehicle)
        vehicles.items = items.sorted { $0.dateCreated < $1.dateCreated }
    }
    
    private func deleteEKEvents(vehicle: Vehicle, at indexSet: IndexSet) {
        let eventIDs = indexSet.compactMap { vehicle.events[$0].localCalendarID }
        do {
            try eventStoreManager.removeEvents(withIDs: eventIDs)
        } catch {
            print(error)
        }
    }
}
