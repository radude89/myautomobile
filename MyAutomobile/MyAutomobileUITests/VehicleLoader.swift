import SwiftUI

struct VehicleLoader {
    static func loadAll() -> [MockVehicle] {
        guard let vehiclesJSON = loadJSON() else { return [] }

        let vehicleDataArray =
        vehiclesJSON.en +
        vehiclesJSON.es +
        vehiclesJSON.it +
        vehiclesJSON.fr +
        vehiclesJSON.ro +
        vehiclesJSON.de

        return vehicleDataArray.map(MockVehicle.init)
    }

    private static func loadJSON() -> VehiclesJSON? {
        let url = Bundle(for: MyAutomobileUITests.self)
            .url(forResource: "vehicles", withExtension: "json")
        guard let url,
              let data = try? Data(contentsOf: url),
              let vehiclesJSON = try? JSONDecoder().decode(VehiclesJSON.self, from: data) else {
            print("Failed to load vehicles.json")
            return nil
        }

        return vehiclesJSON
    }
}

private extension MockVehicle {
    init(data: VehicleData) {
        plate = data.plate
        locationInfo = data.state ?? data.region ?? ""
        make = data.make
        model = data.model
        colorHex = data.color
    }
}
