//
//  ModelJSON.swift
//  MyAutomobile
//
//  Created by Radu Dan on 09.02.2026.
//

import Foundation

struct ModelJSON<T: Decodable>: Decodable {
    let en: [T]
    let fr: [T]
    let it: [T]
    let es: [T]
    let ro: [T]
    let de: [T]
}
