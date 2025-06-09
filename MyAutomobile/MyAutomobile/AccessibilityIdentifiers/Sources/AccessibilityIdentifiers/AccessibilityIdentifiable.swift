//
//  AccessibilityIdentifiable.swift
//  MyAutomobile
//
//  Created by Radu Dan on 06.06.2025.
//

import Foundation

public protocol AccessibilityIdentifiable {
    var id: String { get }
    static var id: String { get }
}

public extension AccessibilityIdentifiable {
    var id: String {
        Self.id
    }

    static var id: String {
        let fullName = String(reflecting: self)
        let components = fullName.components(separatedBy: ".")
        return if components.count > 1 {
            components.dropFirst().joined(separator: ".")
        } else {
            fullName
        }

    }
}
