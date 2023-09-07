/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The data model for the app.
*/

import EventKit

@MainActor
class EventStoreManager: ObservableObject {
    /// Contains fetched events when the app receives a full-access authorization status.
    @Published var events: [EKEvent]
    
    /// Specifies the authorization status for the app.
    @Published var authorizationStatus: EKAuthorizationStatus
    
    private(set) var dataStore: EventDataStore
    
    init(store: EventDataStore = EventDataStore()) {
        self.dataStore = store
        self.events = []
        self.authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    func setupEventStore() async throws {
        _ = try await dataStore.verifyAuthorizationStatus()
        authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    func removeEvents(withIDs ids: [String]) async throws {
        try await dataStore.removeEvents(withIDs: ids)
    }
    
    func makeEKEvent(for event: Event?) -> EKEvent {
        guard let event else {
            return .init(eventStore: dataStore.eventStore)
        }

        let localEvent = EKEvent(eventStore: dataStore.eventStore)
        localEvent.title = event.description
        localEvent.startDate = event.date
        localEvent.endDate = Date(timeInterval: 60 * 5, since: event.date)
        localEvent.recurrenceRules = makeEKRecurrenceRules(for: event)
        return localEvent
    }
    
    private func makeEKRecurrenceRules(for event: Event?) -> [EKRecurrenceRule] {
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

// MARK: - Event

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
