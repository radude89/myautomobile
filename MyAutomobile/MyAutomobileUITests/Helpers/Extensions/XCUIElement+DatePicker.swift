//
//  XCUIElement+DatePicker.swift
//  MyAutomobile
//
//  Created by Radu Dan on 03.02.2026.
//

import XCTest

extension XCUIElement {
    func navigateToMonth(
        targetDate: Date,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let monthButton = buttons["DatePicker.Show"]

        guard monthButton.waitForExistence(timeout: 5) else {
            XCTFail("DatePicker.Show button not found", file: file, line: line)
            return
        }

        guard let currentMonthString = monthButton.value as? String else {
            XCTFail("Could not get current month value from DatePicker.Show", file: file, line: line)
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"

        guard let displayedDate = formatter.date(from: currentMonthString) else {
            XCTFail("Could not parse displayed month: \(currentMonthString)", file: file, line: line)
            return
        }

        let monthsDiff = monthsDifference(from: displayedDate, to: targetDate)

        if monthsDiff > 0 {
            let nextButton = buttons["DatePicker.NextMonth"]
            for _ in 0..<monthsDiff {
                nextButton.tap()
            }
        } else if monthsDiff < 0 {
            let prevButton = buttons["DatePicker.PreviousMonth"]
            for _ in 0..<abs(monthsDiff) {
                prevButton.tap()
            }
        }
    }
    
    private func monthsDifference(from fromDate: Date, to toDate: Date) -> Int {
        let calendar = Calendar.current
        let fromComponents = calendar.dateComponents([.year, .month], from: fromDate)
        let toComponents = calendar.dateComponents([.year, .month], from: toDate)

        guard let fromYear = fromComponents.year,
              let fromMonth = fromComponents.month,
              let toYear = toComponents.year,
              let toMonth = toComponents.month else {
            return 0
        }

        let fromTotal = fromYear * 12 + fromMonth
        let toTotal = toYear * 12 + toMonth

        return toTotal - fromTotal
    }
    
    func tapDay(_ date: Date) {
        let collectionView = collectionViews.firstMatch

        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEMMMMd")
        let dayLabel = formatter.string(from: date)

        let predicate = NSPredicate(format: "label == %@ OR label CONTAINS %@", dayLabel, dayLabel)
        let dayButton = collectionView.buttons.matching(predicate).firstMatch

        if dayButton.waitForExistence(timeout: 2) {
            dayButton.tap()
        } else {
            XCTFail("Could not find day button for label: \(dayLabel)")
        }
    }
}
