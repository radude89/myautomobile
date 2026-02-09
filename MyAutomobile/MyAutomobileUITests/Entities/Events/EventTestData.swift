import Foundation

struct EventTestData {
    let title: String
    let recurrence: Recurrence
    let vehiclePlate: String
    let occurrence: Ocurrence
}

extension EventTestData {
    enum Recurrence: Int {
        case oneTime
        case weekly
        case monthly
        case everyQuarter
        case everySixMonths
        case everyYear
    }

    enum Ocurrence {
        case yesterday
        case today
        case tomorrow
        case nextWeek
        case twoWeeksFromNow
    }
}

extension EventTestData.Ocurrence {
    var inDays: Int {
        switch self {
        case .yesterday: -1
        case .today: 0
        case .tomorrow: 1
        case .nextWeek: 7
        case .twoWeeksFromNow: 14
        }
    }
}
