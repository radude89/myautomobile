//
//  ParkLocationView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.10.2023.
//

import SwiftUI
import MapKit

@MainActor
struct ParkLocationView: View {
    
    @State private var showInfoAlert = false
    @State private var parkingCoordinate: CLLocationCoordinate2D?
    
    private let locationHandler = LocationManager()
    private let parkingLocation = ParkingLocation()
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Parking")
                .onAppear {
                    locationHandler.requestLocation()
                    parkingCoordinate = parkingLocation.coordinate
                }
                .parkLocationToolbar(
                    clearButtonIsDisabled: parkingCoordinate == nil,
                    onTapInfo: {
                        showInfoAlert = true
                    },
                    onTapClear: {
                        parkingCoordinate = nil
                    }
                )
                .alert("Map info", isPresented: $showInfoAlert) {
                    Button("OK", role: .cancel) {
                        showInfoAlert = false
                    }
                } message: {
                    Text("alert_map_info")
                }
                .onChange(of: parkingCoordinate) { oldValue, newValue in
                    if oldValue != newValue {
                        parkingLocation.updateLocation(newValue)
                    }
                }
        }
    }
}
   
// MARK: - Private
private extension ParkLocationView {
    @ViewBuilder
    var contentView: some View {
        if locationHandler.state == .authorized {
            ParkingMapView(parkingCoordinate: $parkingCoordinate)
        } else {
            emptyView
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 16) {
            Text("map_empty")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing], 32)
            Button("Open Settings") {
                openURLSettings()
            }
        }
    }
    
    func openURLSettings() {
        let sharedApp = UIApplication.shared
        if let url = URL(string: UIApplication.openSettingsURLString),
           sharedApp.canOpenURL(url) {
            sharedApp.open(url)
        }
    }
}
