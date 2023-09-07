//
//  EventListRowView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 02.09.2023.
//

import SwiftUI

struct EventListRowView: View {
    let event: Event

    var body: some View {
        HStack {
            VStack {
                Text(event.description)
                    .font(.body)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Recurrence: \(event.recurrence.rawValue)")
                    .font(.caption)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(event.date, style: .date)
                    .font(.caption)
                    .foregroundColor(alarmColor)
                    .italic()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Image(systemName: "alarm")
                .foregroundColor(alarmColor)
                .padding()
        }
    }
    
    private var alarmColor: Color {
        let calendar = Calendar.autoupdatingCurrent
        if event.date <= .now {
            return .red
        } else if calendar.isDateInTomorrow(event.date) {
            return .orange
        } else {
            return .mint
        }
    }
}
