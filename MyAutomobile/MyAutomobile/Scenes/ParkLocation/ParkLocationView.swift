//
//  ParkLocationView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 15.10.2023.
//

import SwiftUI
import MapKit

struct ParkLocationView: View {
    var body: some View {
        NavigationStack {
            Map {
                Marker("Parking", coordinate: .init(latitude: 1, longitude: 1))
            }
                .navigationTitle("Parking Spot")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: addMarker) {
                            Image(systemName: "plus")
                        }
                    }
                }
        }
    }
    
    private func addMarker() {
        
    }
}

#Preview {
    ParkLocationView()
}
