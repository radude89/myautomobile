//
//  GarageView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct GarageView: View {
    
    @State private var vehicles: [Vehicle]
    
    init(vehicles: [Vehicle] = []) {
        self.vehicles = vehicles
    }
    
    var body: some View {
        NavigationView {
            contentView
                .navigationTitle("Vehicles")
        }
    }
    
    private var contentView: some View {
        if vehicles.isEmpty {
            return AnyView(
                Text("You haven't added any vehicles.")
                    .font(.body)
                    .multilineTextAlignment(.center)
            )
        } else {
            return AnyView(
                List(vehicles) { vehicle in
                    HStack {
                        VehicleImage(image: vehicle.icon)
                            .padding([.top, .bottom])
                        
                        VStack(alignment: .leading) {
                            Text(vehicle.numberPlate)
                                .font(.title2)
                                .bold()
                                .foregroundColor(.primary)
                            
                            Text("\(vehicle.make) \(vehicle.model)")
                        }
                        .padding()
                    }
                }
            )
        }
    }
    
}

private extension Vehicle {
    var icon: UIImage {
        .init(data: photoData!)!
    }
}

private struct VehicleImage: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .shadow(radius: 4)
            .overlay(
                Circle()
                    .stroke(.gray, lineWidth: 1)
            )
        
    }
}

// MARK: - Previews

struct GarageView_Previews: PreviewProvider {
    private static let cars: [Vehicle] = [
        .init(make: "Dacia", model: "Duster", numberPlate: "AA-123-RAD", photoData: UIImage(named: "duster")!.jpegData(compressionQuality: 1)!),
        .init(make: "Renault", model: "Kangoo", numberPlate: "AA-124-RAD", photoData: UIImage(named: "amg")!.jpegData(compressionQuality: 1)!)
    ]
    
    static var previews: some View {
        GarageView(vehicles: cars)

        GarageView(vehicles: cars)
            .preferredColorScheme(.dark)

        GarageView()
            .preferredColorScheme(.dark)
    }
}
