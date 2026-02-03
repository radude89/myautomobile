//
//  XCTestCase+Helpers.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.02.2026.
//

import XCTest

@MainActor
extension XCTestCase {
    func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
