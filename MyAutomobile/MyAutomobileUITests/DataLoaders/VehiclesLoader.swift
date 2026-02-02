import XCTest
import Foundation

enum VehiclesLoader: DataLoader {
    static func load(supportedLocale: SupportedLocale = .english) -> [VehicleTestData] {
        guard let vehiclesJSON: VehiclesJSON = loadJSON(resource: "vehicles") else { return [] }
        
        let vehicleData = vehiclesJSON[keyPath: supportedLocale.vehiclesKeyPath]
        return vehicleData.map(VehicleTestData.init(vehicleData:))
    }
}

private extension VehicleTestData {
    init(vehicleData: VehicleData) {
        plate = vehicleData.plate
        state = vehicleData.state ?? vehicleData.region ?? ""
        make = vehicleData.make
        model = vehicleData.model
        colorWithoutHash = vehicleData.color.replacingOccurrences(of: "#", with: "")
    }
}
