import Foundation

struct EventData: Decodable {
    let title: String
    let recurrence: String
    let vehicleId: Int
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case recurrence
        case vehicleId = "vehicle_id"
        case date
    }
}
