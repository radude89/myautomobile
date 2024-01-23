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
    
    init(userLocation: CLLocation? = nil) {
        self.userLocation = userLocation
        super.init()
        locationHandler.delegate = self
        locationHandler.desiredAccuracy = kCLLocationAccuracyBest
        locationHandler.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationHandler.requestWhenInUseAuthorization()
        //        locationHandler.requestTemporaryFullAccuracyAuthorization(
        //            withPurposeKey: "parking"
        //        )
    }
    
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
        @unknown default:
            print("Unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        userLocation = location
    }
}
