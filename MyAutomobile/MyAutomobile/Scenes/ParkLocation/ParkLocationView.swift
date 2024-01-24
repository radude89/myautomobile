//
//  ParkLocationView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.10.2023.
//

import SwiftUI
import MapKit

// TODO's
// - add marker with parking location
//
// - clear parking location
//
// - save parking location to local storage
//
// - (?) when coming from background / app termination state present directions, marker etc
// https://www.createwithswift.com/getting-directions-in-mapkit-with-swiftui/

struct ParkLocationView: View {
    private let locationHandler = LocationManager()
    @State private var showInfoAlert = false
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Parking Spot")
                .onAppear {
                    locationHandler.requestLocation()
                }
                .parkLocationToolbar {
                    showInfoAlert = true
                }
                .alert("Map info", isPresented: $showInfoAlert) {
                    Button("OK", role: .cancel) {
                        showInfoAlert = false
                    }
                } message: {
                    Text("alert_map_info")
                }
        }
    }
}
   
// MARK: - Private
private extension ParkLocationView {
    @ViewBuilder
    var contentView: some View {
        if locationHandler.state == .authorized {
            ParkingMapView()
        } else {
            emptyView
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 16) {
            Text("map_empty")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding([.leading, .trailing])
            Button("Open settings", action: openURLSettings)
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
