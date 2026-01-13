//
//  CalendarView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import SwiftUI

struct CalendarView: View {
    
    private enum Constants {
        static let cellHeight: CGFloat = 80
    }
    
    let month: Int
    let year: Int

    private let calendar = Calendar.current
    private let weekDays: [String] = {
        var weekDays = Calendar.current.shortWeekdaySymbols
        weekDays.append(weekDays.removeFirst())
        return weekDays
    }()
    
    var didSelectDay: (Int) -> Void

    var body: some View {
        let listDays = daysForMonth()
        VStack(spacing: 8) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
                                     count: weekDays.count)) {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                }
            }

            LazyVGrid(columns: Array(repeating: GridItem(.flexible()),
                                     count: weekDays.count),
                      spacing: 12) {
                ForEach(listDays, id: \.self) { date in
                    if let date = date {
                        Text("\(calendar.component(.day, from: date))")
                            .frame(maxWidth: .infinity,
                                   minHeight: Constants.cellHeight)
                            .onTapGesture {
                                if let index = listDays.compactMap({$0}).firstIndex(of: date) {
                                    print("date: \(date), index: \(index)")
                                    didSelectDay(index)
                                }
                            }
                    } else {
                        Color.clear
                    }
                }
            }
        }
        .padding()
    }

    // MARK: - Helpers

    private func daysForMonth() -> [Date?] {
        guard
            let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month + 1)),
            let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)
        else { return [] }

        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let leadingEmptyDays = (firstWeekday + 5) % 7

        var days: [Date?] = Array(repeating: nil, count: leadingEmptyDays)

        for day in range {
            let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)
            days.append(date)
        }
        return days
    }
}

#Preview {
    CalendarView(month: 5, year: 2026, didSelectDay: {_ in})
}
