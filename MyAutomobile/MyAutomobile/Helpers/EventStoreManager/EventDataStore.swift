/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Manages reading and writing data from the event store.
*/

import EventKit

actor EventDataStore {
    let eventStore: EKEventStore
    
    init() {
        self.eventStore = EKEventStore()
    }
    
    /// Verifies the authorization status for the app.
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
    
    /// Prompts the user for full-access authorization to Calendar.
    private func requestFullAccess() async throws -> Bool {
        try await eventStore.requestFullAccessToEvents()
    }
}
  
// MARK: - Event object

extension EventDataStore {
    func addEvent(_ event: Event, date: Date, calendar: EKCalendar? = nil) throws {
        // TODO: add event here
    }
    
    /// Batches all the remove operations.
    func removeEvents(_ events: [EKEvent]) throws {
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
    
    /// Removes an event.
    private func removeEvent(_ event: EKEvent) throws {
        try self.eventStore.remove(event, span: .thisEvent, commit: false)
    }
}
