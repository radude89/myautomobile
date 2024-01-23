//
//  ParkLocationView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.10.2023.
//

import CoreLocation
import SwiftUI
import MapKit

struct ParkLocationView: View {
    
    private let locationHandler = LocationManager()
    @State private var cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    
    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    UserAnnotation()
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        print(coordinate)
                    }
                }
            }
            .navigationTitle("Parking Spot")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: addMarker) {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                locationHandler.requestLocation()
            }
        }
    }
    
    private func addMarker() {
        
    }
    
}

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
