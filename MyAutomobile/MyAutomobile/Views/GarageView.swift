//
//  GarageView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 19.04.2022.
//

import SwiftUI

struct GarageView: View {
    
    @State private var cars = [Vehicle]()
    
    var body: some View {
        NavigationView {
            List(cars) { car in
                HStack {
                    VehicleImage(image: car.icon)
                    
                    VStack(alignment: .leading) {
                        Text(car.numberPlate)
                            .font(.title2)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Text("\(car.make) \(car.model)")
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Vehicles")
            .listStyle(.plain)
            .onAppear(perform: loadCars)
        }
    }
    
    private func loadCars() {
        cars = [
            .init(make: "Dacia", model: "Duster", numberPlate: "AA-123-RAD", photoData: UIImage(named: "duster")!.jpegData(compressionQuality: 1)!),
            .init(make: "Renault", model: "Kangoo", numberPlate: "AA-124-RAD", photoData: UIImage(named: "amg")!.jpegData(compressionQuality: 1)!)
        ]
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

struct GarageView_Previews: PreviewProvider {
    static var previews: some View {
        GarageView()
        
        GarageView()
            .preferredColorScheme(.dark)
    }
}
