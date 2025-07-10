//
//  Behi.swift
//  MyAutomobile
//
//  Created by Radu Dan on 08.07.2025.
//

import XCTest
import Foundation

enum VehicleLoader {
    static func load(
        supportedLocale: SupportedLocale = .english,
        line: UInt = #line
    ) -> [VehicleTestData] {
        guard let vehiclesJSON = loadVehiclesJSON(line: line) else {
            return []
        }
        
        let vehicleData = vehiclesJSON[keyPath: supportedLocale.keyPath]
        return vehicleData.map(VehicleTestData.init(vehicleData:))
    }
}

// MARK: - Private methods

private extension VehicleLoader {
    static func loadVehiclesJSON(line: UInt) -> VehiclesJSON? {
        guard let url = Bundle(for: VehicleUITests.self)
            .url(forResource: "vehicles", withExtension: "json") else {
            XCTFail("Failed to find vehicles.json file", line: line)
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Failed to load data from vehicles.json", line: line)
            return nil
        }
        
        guard let vehiclesJSON = try? JSONDecoder().decode(VehiclesJSON.self, from: data) else {
            XCTFail("Failed to decode vehicles.json", line: line)
            return nil
        }
        
        return vehiclesJSON
    }
    
    static func selectVehicleData(
        from vehiclesJSON: VehiclesJSON,
        locale: SupportedLocale
    ) -> [VehicleData] {
        return vehiclesJSON[keyPath: locale.keyPath]
    }
    
}

// MARK: - VehicleTestData

private extension VehicleTestData {
    init(vehicleData: VehicleData) {
        plate = vehicleData.plate
        state = vehicleData.state ?? vehicleData.region ?? ""
        make = vehicleData.make
        model = vehicleData.model
        colorWithoutHash = vehicleData.color.replacingOccurrences(of: "#", with: "")
    }
}
