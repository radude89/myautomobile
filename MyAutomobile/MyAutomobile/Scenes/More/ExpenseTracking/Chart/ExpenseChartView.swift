//
//  ExpenseChartView.swift
//  MyAutomobile
//
//  Created by Radu Dan on 06.02.2024.
//

import SwiftUI
import Charts

struct ExpenseChartView: View {
    @State private var selectedCount: Double?
    @State private var selectedExpense: ExpenseData?
    
    private let expenseData: [ExpenseData]
    
    init(expenseData: [ExpenseData]) {
        self.expenseData = expenseData
    }
    
    var body: some View {
        VStack {
            Chart(expenseData, id: \.expenseType.rawValue) { expense in
                SectorMark(
                    angle: .value("Cost", expense.cost),
                    innerRadius: .ratio(0.5),
                    outerRadius: expense == selectedExpense ? 160 : 140,
                    angularInset: 4
                )
                .foregroundStyle(
                    expense.expenseType.color
                )
                .cornerRadius(12)
            }
            .chartGesture { chart in
                SpatialTapGesture().onEnded { event in
                    let angle = chart.angle(at: event.location)
                    chart.selectAngleValue(at: angle)
                }
            }
            .chartAngleSelection(value: $selectedCount)
            .chartBackground { _ in
                if let selectedExpense {
                    VStack {
                        Image(systemName: selectedExpense.expenseType.imageName)
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(Circle())
                            .foregroundStyle(selectedExpense.expenseType.color)
                            .overlay(Circle().stroke(Color.primary.opacity(0.2), lineWidth: 0.5))
                        Text(selectedExpense.expenseType.name)
                            .font(.body)
                            .bold()
                            .foregroundStyle(selectedExpense.expenseType.color)
                        Text("\(selectedExpense.cost)$")
                            .font(.caption)
                            .foregroundStyle(selectedExpense.expenseType.color)
                    }
                } else {
                    Text("Tap on a segment")
                        .font(.caption2)
                }
            }
        }
        .onChange(of: selectedCount) { oldValue, newValue in
            if let newValue {
                withAnimation {
                    getSelectedExpense(value: newValue)
                }
            }
        }
        .onAppear {
            let types = Set(expenseData.map { $0.expenseType })
            if types.count == 1 {
                selectedExpense = expenseData.first
            }
        }
        .padding()
    }
    
    private func getSelectedExpense(value: Double) {
        var cumulativeTotal = 0.0
        selectedExpense = expenseData.first { expense in
            cumulativeTotal += expense.cost
            if value <= cumulativeTotal {
                return true
            }
            return false
        }
    }
}
