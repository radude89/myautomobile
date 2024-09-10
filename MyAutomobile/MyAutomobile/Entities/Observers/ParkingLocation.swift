//
//  ParkingLocation.swift
//  MyAutomobile
//
//  Created by Radu Dan on 26.01.2024.
//

import SwiftUI
import Observation
import CoreLocation

final class ParkingLocation {
    private static let storageKey = "saved-location"
    
    var coordinate: CLLocationCoordinate2D? {
        guard let locationCoordinate = loadData() else {
            return nil
        }
        
        return .init(
            latitude: locationCoordinate.latitude,
            longitude: locationCoordinate.longitude
        )
    }

    func updateLocation(_ coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else {
            deleteData()
            return
        }
        
        let locationCoordinate = ParkingLocationCoordinate(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        saveLocation(at: locationCoordinate)
    }
}

// MARK: - Private
private extension ParkingLocation {
    func saveLocation(at locationCoordinate: ParkingLocationCoordinate) {
        do {
            let data = try JSONEncoder().encode(locationCoordinate)
            try FileManager.write(data: data, fileName: Self.storageKey)
        } catch {
            print("Unable to save data, error: \(error.localizedDescription)")
        }
    }
    
    func loadData() -> ParkingLocationCoordinate? {
        do {
            let data = try FileManager.readData(fileName: Self.storageKey)
            return try JSONDecoder().decode(ParkingLocationCoordinate.self, from: data)
        } catch {
            print("Unable to load data, error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    func deleteData() {
        do {
            try FileManager.deleteFile(fileName: Self.storageKey)
        } catch {
            print("Unable to delete data, error \(error.localizedDescription)")
        }
    }
}
