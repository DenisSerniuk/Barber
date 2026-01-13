//
//  ContentView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 08.01.2026.
//

import SwiftUI


fileprivate struct SelectMonthActionType: SelectMonthAction {
    var month: Int
}

fileprivate struct SelectDayActionType: SelectDayAction {
    var day: Int
}

struct ContentView: View {
    @EnvironmentObject var store: Store
    @State var isShowDayView: Bool = false
    
    struct Prompt {
        let monthIndex: Int
        let currentMonth: Int
        let dayIndex: Int
        let isShowDayView: Bool
        var didSelectMonth: (Int) -> Void
        var didSelectDay: (Int) -> Void
    }

    func map(_ appState: AppState) -> Prompt {
        Prompt(monthIndex: appState.month,
               currentMonth: appState.minMonth,
               dayIndex: appState.day,
               isShowDayView: appState.showDay) { index in
            store.dispatch(SelectMonthActionType(month: index))
        } didSelectDay: { index in
            isShowDayView = true
            store.dispatch(SelectDayActionType(day: index))
        }
    }
    
    var body: some View {
        let prompt = map(store.state)
        
        NavigationStack {
            if isShowDayView == true,
                prompt.isShowDayView,
                let date = Date.dateFromMonthIndex(prompt.monthIndex,
                                                   year: currentYear()) {
                DayView(dayIndex: prompt.dayIndex,
                        daysOfMonth: Date.daysOfMonth(month: date),
                        showSheet: $isShowDayView)
            } else {
                ZStack {
                    Color.appBackground.ignoresSafeArea()
                    VStack {
                        MonthView(startMonth: prompt.monthIndex,
                                  currentMonth: prompt.currentMonth,
                                  didSelectMonth:prompt.didSelectMonth).frame(height: 70)
                        CalendarView(month: prompt.monthIndex,
                                     year: currentYear(),
                                     didSelectDay: prompt.didSelectDay)
                        Spacer()
                    }.padding()
                        .navigationTitle(monthIndexToString(prompt.monthIndex))
                        .navigationBarTitleDisplayMode(.inline)
                        .tint(.white)
                }
            }
        }
    }
    
    func monthIndexToString(_ index: Int) -> String {
        let monthSymbols = Calendar.current.monthSymbols
        return monthSymbols[index]
    }
    
    func currentYear() -> Int {
        Calendar.current.component(.year, from: Date())
    }
}

#Preview {
    ContentView()
}
