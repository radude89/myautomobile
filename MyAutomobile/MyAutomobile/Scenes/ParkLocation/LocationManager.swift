//
//  LocationManager.swift
//  MyAutomobile
//
//  Created by Radu Dan on 23.01.2024.
//

import SwiftUI
import Observation
import CoreLocation

@Observable
final class LocationManager: NSObject {
    
    private let locationHandler = CLLocationManager()
    
    var userLocation: CLLocation?
    var state: State = .permissionsNotChecked
    
    init(userLocation: CLLocation? = nil) {
        self.userLocation = userLocation
        super.init()
        locationHandler.delegate = self
        locationHandler.desiredAccuracy = kCLLocationAccuracyBest
        locationHandler.startUpdatingLocation()
    }
    
}

// MARK: - Public API
extension LocationManager {
    func requestLocation() {
        locationHandler.requestWhenInUseAuthorization()
    }
}

// MARK: - State
extension LocationManager {
    enum State {
        case authorized
        case permissionsNotChecked
        case disabled
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        updateState(locationManager: manager)
    }
    
    private func updateState(locationManager: CLLocationManager) {
        switch locationManager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            state = .authorized
            requestFullAccuracyIfNeeded(locationManager: locationManager)
        default:
            state = .disabled
        }
    }
    
    private func requestFullAccuracyIfNeeded(locationManager: CLLocationManager) {
        if locationManager.accuracyAuthorization != .fullAccuracy {
            locationHandler.requestTemporaryFullAccuracyAuthorization(
                withPurposeKey: "parking"
            )
        }
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else {
            return
        }
        
        userLocation = location
    }
}
