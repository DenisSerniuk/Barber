//
//  Date+Helper.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import Foundation

extension Date {
    private enum Constants {
        static let hour: TimeInterval = 3600
    }
    
    func toTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH a"
        return formatter.string(from: self)
    }
    
    func shortDayTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        return self.formatted(.dateTime.weekday(.abbreviated)) + "\n" + formatter.string(from: self)
    }
    
    func hourAndMinute() -> (hour: Int, minute: Int) {
        let cal = Calendar.current
        let hour = cal.component(.hour, from: self)
        let minute = cal.component(.minute, from: self)
        return (hour,minute)
    }
    
    static func startDay(startHour: Int) -> Date {
        guard let specificTimeDate = Calendar.current.date(bySetting: .hour,
                                                           value: startHour,
                                                           of: Date()) else {
            return Date()
        }
                
        return specificTimeDate
    }
    
    static func workDay(from start: Int, hours: Int = 10) -> [Date] {
        let startDate = Date.startDay(startHour: start)
        var list: [Date] = [startDate]
        var nextDate: Date = startDate
        for _ in 0 ..< hours {
            nextDate = nextDate.addingTimeInterval(Constants.hour)
            list.append(nextDate)
        }
        
        return list
    }
    
    static func daysOfMonth(month: Date) -> [Date] {
        let calendar = Calendar.current
        if let range = calendar.range(of: .day, in: .month, for: month),
           let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: month)) {
            
            let days = range.compactMap { day in
                calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
            }
            return days
        } else {
            return []
        }
    }
    
    static func dateFromMonthIndex(_ monthIndex: Int, year: Int) -> Date? {
        guard monthIndex >= 1 && monthIndex <= 12 else {
            print("Invalid month index. Must be between 1 and 12.")
            return nil
        }

        var calendar = Calendar.current

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = monthIndex
        dateComponents.day = 1

        return calendar.date(from: dateComponents)
    }
    
    func hourIndex() -> Int {
        var calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        return hour
    }
    
    func startDay() -> Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        return startOfDay
    }
}
