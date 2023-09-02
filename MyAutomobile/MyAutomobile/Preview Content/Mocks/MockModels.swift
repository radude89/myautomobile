//
//  Demo.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.05.2022.
//

import UIKit

extension Vehicle {
    static let demoVehicles = Array.demoVehicles
}

extension Event {
    static let demoEvents = Array.demoEvents
}

extension Array where Self.Element == Vehicle {
    static let demoVehicles: [Vehicle] = [
        .init(make: "Dacia", model: "Duster", numberPlate: "AA-123-RAD", color: .cyan, events: .demoEvents),
        .init(make: "Renault", model: "Kangoo", numberPlate: "AA-124-RAD", color: .cyan, events: .demoEvents)
    ]
}

extension Array where Self.Element == Event {
    static let demoEvents: [Event] = [
        Event(date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 2, to: .now)!, description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: 1, to: .now)!, description: "Rata masina"),
        Event(date: Calendar.autoupdatingCurrent.date(byAdding: .day, value: -2, to: .now)!, description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta"),
        Event(date: Date(), description: "ITP long long long long long long long long long long long long long long text"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta"),
        Event(date: Date(), description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta"),
        Event(date: Date(), description: "ITP"),
        Event(date: Date(), description: "CASCO"),
        Event(date: Date(), description: "Rata masina"),
        Event(date: Date(), description: "Extinctor"),
        Event(date: Date(), description: "Rovinieta")
    ]
}
