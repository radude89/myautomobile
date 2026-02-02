import XCTest
import Foundation

enum EventsLoader: DataLoader {
    static func load(supportedLocale: SupportedLocale = .english) -> [EventTestData] {
        guard let eventsJSON: EventsJSON = loadJSON(resource: "events") else { return [] }
        guard let vehiclesJSON: VehiclesJSON = loadJSON(resource: "vehicles") else { return [] }
        
        let events = eventsJSON[keyPath: supportedLocale.eventsKeyPath]
        let vehicles = vehiclesJSON[keyPath: supportedLocale.vehiclesKeyPath]
        return events.map { event in
            EventTestData(eventsData: event, vehicles: vehicles)
        }
    }
}

private extension EventTestData {
    init(eventsData: EventData, vehicles: [VehicleData]) {
        title = eventsData.title

        if let vehicle = vehicles.first(where: { vehicle in
            vehicle.id == eventsData.vehicleId
        }) {
            vehiclePlate = vehicle.plate
        } else {
            vehiclePlate = ""
        }

        occurrence = switch eventsData.date {
        case "yesterday": .yesterday
        case "today": .today
        case "tomorrow": .tomorrow
        case "next week": .nextWeek
        case "two weeks from today": .twoWeeksFromNow
        default: .today
        }
        
        recurrence = switch eventsData.recurrence {
        case "Every quarter": .everyQuarter
        case "One time": .oneTime
        case "Weekly": .weekly
        case "Every year": .everyYear
        default: .oneTime
        }
    }
}
