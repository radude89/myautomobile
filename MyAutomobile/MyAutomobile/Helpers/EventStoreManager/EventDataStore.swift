import EventKit

final class EventDataStore {
    let eventStore: EKEventStore
    
    init(eventStore: EKEventStore = .init()) {
        self.eventStore = eventStore
    }
    
    func verifyAuthorizationStatus() async throws -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            return try await requestFullAccess()
        case .fullAccess, .writeOnly:
            return true
        case .restricted:
            throw EventStoreError.restricted
        case .denied:
            throw EventStoreError.denied
        @unknown default:
            throw EventStoreError.unknown
        }
    }
    
    private func requestFullAccess() async throws -> Bool {
        try await eventStore.requestFullAccessToEvents()
    }

    func removeEvents(withIDs ids: [String]) throws {
        let events = ids.compactMap { eventStore.event(withIdentifier: $0) }
        do {
            try events.forEach { event in
                try removeEvent(event)
            }
            try eventStore.commit()
         } catch {
             eventStore.reset()
             throw error
         }
    }
    
    private func removeEvent(_ event: EKEvent) throws {
        try self.eventStore.remove(event, span: .thisEvent, commit: false)
    }
}
