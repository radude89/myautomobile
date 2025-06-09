import Foundation

struct VehicleData: Decodable {
    let plate: String
    let state: String?
    let region: String?
    let make: String
    let model: String
    let color: String
}
