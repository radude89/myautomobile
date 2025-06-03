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
        HStack(spacing: 16) {
            // Status indicator circle
            Circle()
                .fill(alarmColor)
                .frame(width: 12, height: 12)

            VStack(alignment: .leading, spacing: 6) {
                // Event title
                Text(event.description)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)

                // Recurrence info
                HStack(spacing: 4) {
                    Image(systemName: "repeat")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(event.recurrence.longLocalizedKey)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                // Date info
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(alarmColor)
                    Text(event.date, style: .date)
                        .font(.caption)
                        .foregroundColor(alarmColor)
                        .fontWeight(.medium)
                }
            }

            Spacer()

            // Alarm icon with background
            ZStack {
                Circle()
                    .fill(alarmColor.opacity(0.1))
                    .frame(width: 40, height: 40)

                Image(systemName: "alarm.fill")
                    .font(.system(size: 18))
                    .foregroundColor(alarmColor)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .listRowSeparator(.hidden)
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
