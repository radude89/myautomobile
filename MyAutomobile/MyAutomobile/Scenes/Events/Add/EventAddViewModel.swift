//
//  EventAddViewModel.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI
import EventKitUI

final class EventAddViewModel: ObservableObject {
    
    @ObservedObject var vehicles: Vehicles

    private var event: Event?
    private let eventStore: EKEventStore
    
    init(vehicles: Vehicles, eventStore: EKEventStore) {
        self.vehicles = vehicles
        self.eventStore = eventStore
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
        self.event = event
    }
    
    func makeEKEvent() -> EKEvent {
        guard let event else {
            return .init(eventStore: eventStore)
        }

        let localEvent = EKEvent(eventStore: eventStore)
        localEvent.title = event.description
        localEvent.startDate = event.date
        localEvent.endDate = Date(timeInterval: 60 * 5, since: event.date)
        localEvent.recurrenceRules = makeEKRecurrenceRules()
        return localEvent
    }
    
    func makeEKRecurrenceRules() -> [EKRecurrenceRule] {
        guard let event, let frequency = event.frequency else {
            return []
        }
        
        return [
            .init(
                recurrenceWith: frequency,
                interval: event.interval,
                end: .init(occurrenceCount: 1)
            )
        ]
    }
    
}

extension Event {
    var frequency: EKRecurrenceFrequency? {
        switch recurrence {
        case .weekly:
            return .weekly
        case .monthly, .quarterly, .everySixMonths:
            return .monthly
        case .yearly:
            return .yearly
        case .once:
            return nil
        }
    }
    
    var interval: Int {
        switch recurrence {
        case .weekly, .monthly, .yearly, .once:
            return 1
        case .quarterly:
            return 3
        case .everySixMonths:
            return 6
        }
    }
}
