import XCTest
import Foundation

enum EventsLoader: DataLoader {
    static func load(supportedLocale: SupportedLocale = .english) -> [EventTestData] {
        guard let json: EventsJSON = loadJSON(resource: "events") else { return [] }
        
        let eventsData = json[keyPath: supportedLocale.eventsKeyPath]
//        return eventsData.map(VehicleTestData.init(vehicleData:))
        return []
    }
}

// MARK: - VehicleTestData

// TODO: Change the domain model so it has enums and all that stuff
private extension EventTestData {
}
