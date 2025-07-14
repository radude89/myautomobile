import Foundation

struct VehicleData: Decodable {
    let id: Int
    let plate: String
    let state: String?
    let region: String?
    let make: String
    let model: String
    let color: String
}
