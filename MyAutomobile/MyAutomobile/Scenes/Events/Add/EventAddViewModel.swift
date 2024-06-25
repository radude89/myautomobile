//
//  EventAddViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI
import EventKitUI

@MainActor
final class EventAddViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles

    private let eventStoreManager: EventStoreManager
    private var event: Event?
    private var vehicleIndex: Int?
    
    init(vehicles: Vehicles, eventStoreManager: EventStoreManager) {
        self.vehicles = vehicles
        self.eventStoreManager = eventStoreManager
    }
    
    var items: [Vehicle] {
        vehicles.items
    }
    
    var dataStore: EventDataStore {
        eventStoreManager.dataStore
    }
    
    var showSyncWithLocalCalendarSection: Bool {
        switch eventStoreManager.authorizationStatus {
        case .notDetermined, .fullAccess, .writeOnly:
            return true
        default:
            return false
        }
    }
    
    func setupEventStore() async {
        do {
            try await eventStoreManager.setupEventStore()
        } catch {
            print(error)
        }
    }
    
    func saveEvent(
        date: Date,
        titleText: String,
        recurrenceIndex: Int,
        vehicleIndex: Int
    ) {
        let event = Event(date: date, description: titleText, recurrence: Event.Recurrence.allCases[recurrenceIndex])
        vehicles.items[vehicleIndex].events.append(event)
        self.event = event
        self.vehicleIndex = vehicleIndex
    }
    
    func set(eventLocalID: String?) {
        guard let eventLocalID, let vehicleIndex, var event else {
            return
        }
        
        event.localCalendarID = eventLocalID
        var events = vehicles.items[vehicleIndex].events
        events.removeAll { $0.id == event.id }
        events.append(event)
        vehicles.items[vehicleIndex].events = events
    }
    
    func makeEKEvent() -> EKEvent {
        eventStoreManager.makeEKEvent(for: event)
    }
    
}
