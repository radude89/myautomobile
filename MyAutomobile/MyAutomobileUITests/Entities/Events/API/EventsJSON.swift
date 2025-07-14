import Foundation

struct EventsJSON: Decodable {
    let en: [EventData]
    let fr: [EventData]
    let it: [EventData]
    let es: [EventData]
    let ro: [EventData]
    let de: [EventData]
}
