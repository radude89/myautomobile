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
    
    func deleteEvent(
        at indexSet: IndexSet,
        sortOption: Int,
        section: Int = 0
    ) {
        guard let tappedIndex = indexSet.first,
              let sortOptionEnum = EventListSortOption(rawValue: sortOption) else {
            return
        }
        
        switch sortOptionEnum {
        case .all:
            deleteEventWhenAllAreShown(tappedIndex: tappedIndex)
        case .byVehicle:
            deleteEventWhenOptionIsByVehicle(
                section: section,
                tappedIndex: tappedIndex
            )
        }
    }
    
    private func deleteEventWhenAllAreShown(tappedIndex: Int) {
        let eventToDelete = allEvents[tappedIndex]
        guard var vehicle = vehicles.items.first(where: { aVehicle in
            aVehicle.events.contains { $0.id == eventToDelete.id }
        }) else {
            return
        }
        deleteEvent(eventToDelete, vehicle: &vehicle)
    }
    
    private func deleteEventWhenOptionIsByVehicle(
        section: Int,
        tappedIndex: Int
    ) {
        var vehicle = vehicles.items[section]
        let eventToDelete = events(for: vehicle)[tappedIndex]
        deleteEvent(eventToDelete, vehicle: &vehicle)
    }
    
    private func deleteEvent(
        _ event: Event,
        vehicle: inout Vehicle
    ) {
        vehicle.events.removeAll { $0.id == event.id }
        updateVehicles(vehicle: vehicle)
        if let localCalendarID = event.localCalendarID {
            deleteCalendarEvent(id: localCalendarID)
        }
    }
    
    private func updateVehicles(vehicle: Vehicle) {
        var items = vehicles.items
        items.removeAll { $0.id == vehicle.id }
        items.append(vehicle)
        vehicles.items = items.sorted { $0.dateCreated < $1.dateCreated }
    }
    
    private func deleteCalendarEvent(id: String) {
        do {
            try eventStoreManager.removeEvents(withIDs: [id])
        } catch {
            print(error)
        }
    }
}
