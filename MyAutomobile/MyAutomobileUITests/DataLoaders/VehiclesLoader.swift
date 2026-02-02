import XCTest
import Foundation

enum VehiclesLoader: DataLoader {
    static func load(supportedLocale: SupportedLocale = .english) -> [VehicleTestData] {
        guard let vehiclesJSON: VehiclesJSON = loadJSON(resource: "vehicles") else { return [] }
        
        let vehicleData = vehiclesJSON[keyPath: supportedLocale.vehiclesKeyPath]
        return vehicleData.map(VehicleTestData.init(vehicleData:))
    }
    
    static func json(supportedLocale: SupportedLocale = .english) -> String? {
        guard let url = Bundle(for: VehicleUITests.self)
            .url(forResource: "vehicles", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let jsonDict = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let localeArray = jsonDict[supportedLocale.rawValue] else {
            return nil
        }

        guard let localeData = try? JSONSerialization.data(withJSONObject: localeArray),
              let jsonString = String(data: localeData, encoding: .utf8) else {
            return nil
        }

        return jsonString
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
