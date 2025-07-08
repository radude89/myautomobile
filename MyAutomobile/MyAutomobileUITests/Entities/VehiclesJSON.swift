import Foundation

struct VehiclesJSON: Decodable {
    let en: [VehicleData]
    let fr: [VehicleData]
    let it: [VehicleData]
    let es: [VehicleData]
    let ro: [VehicleData]
    let de: [VehicleData]
}
