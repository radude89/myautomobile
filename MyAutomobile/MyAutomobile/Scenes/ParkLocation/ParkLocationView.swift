//
//  ParkLocationView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.10.2023.
//

import SwiftUI
import MapKit

struct ParkLocationView: View {
    private let locationHandler = LocationManager()
    @State private var cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    
    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Parking Spot")
                .onAppear {
                    locationHandler.requestLocation()
                }
        }
    }
}
   
private extension ParkLocationView {
    var contentView: some View {
        MapReader { mapProxy in
            Map(position: $cameraPosition) {
                UserAnnotation()
            }
            .mapControls {
                MapUserLocationButton()
            }
            .gesture(DragGesture())
            .gesture(makeLongPressGesture(mapProxy: mapProxy))
        }
    }
    
    func makeLongPressGesture(mapProxy: MapProxy) -> some Gesture {
        LongPressGesture()
            .sequenced(before: DragGesture(minimumDistance: 0))
            .onEnded { findCoordinate(from: $0, mapProxy: mapProxy) }
    }
    
    func findCoordinate(
        from value: SequenceGesture<LongPressGesture, DragGesture>.Value,
        mapProxy: MapProxy
    ) {
        switch value {
        case .second(true, let drag):
            let longPressLocation = drag?.location ?? .zero
            if let coordinate = mapProxy.convert(longPressLocation, from: .local) {
                print(coordinate)
            }
        default:
            break
        }
    }
}
