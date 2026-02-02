import Foundation

struct EventTestData {
    let title: String
    let recurrence: Recurrence
    let vehiclePlate: String
    let occurrence: Ocurrence
}

extension EventTestData {
    enum Recurrence {
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
