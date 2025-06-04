//
//  ParkingMapView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 24.01.2024.
//

import SwiftUI
import MapKit

struct ParkingMapView: View {
    @State private var cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    @Binding var parkingCoordinate: CLLocationCoordinate2D?

    var body: some View {
        MapReader { mapProxy in
            Map(position: $cameraPosition) {
                UserAnnotation()
                if let parkingCoordinate {
                    Annotation("Parking Spot", coordinate: parkingCoordinate) {
                        CustomParkingMarker()
                    }
                }
            }
            .mapControls {
                MapUserLocationButton()
            }
            .gesture(DragGesture())
            .gesture(makeLongPressGesture(mapProxy: mapProxy))
        }
    }
}

// MARK: - Private
private extension ParkingMapView {
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
                parkingCoordinate = coordinate
            }
        default:
            break
        }
    }
}
