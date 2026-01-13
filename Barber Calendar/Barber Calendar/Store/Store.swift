//
//  Store.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import Foundation
import Combine

typealias Reducer = (_ state: AppState, _ action: Action) -> AppState

// MARK: - Action
protocol Action {}

protocol SelectMonthAction: Action {
    var month: Int { get }
}

protocol SelectDayAction: Action {
    var day: Int { get }
}



// MARK: - State
struct AppState {
    var month: Int
    var day: Int
    var minMonth: Int
    var minDay: Int
    var showDay: Bool = false

    init(month: Int = Calendar.current.component(.month, from: Date()),
         day: Int = Calendar.current.component(.day, from: Date())) {
        self.month = month
        self.day = day
        self.minMonth = month
        self.minDay = day
    }

}

// MARK: - Reducer
func reducer(_ state: AppState, _ action: Action) -> AppState {
    
    var state = state
    
    switch action {
    case let action as SelectMonthAction:
        state.month = action.month
    case let action as SelectDayAction:
        state.day = action.day
        state.showDay = true
    default :
        print("do nothing")
    }
    
    return state
}

// MARK: - Store
class Store: ObservableObject {
    
    @Published var state: AppState
    var reducer: Reducer
    
    init(state: AppState, reducer: @escaping Reducer) {
        self.state = state
        self.reducer = reducer
    }
    
    func dispatch(_ action: Action) -> Void {
        state = reducer(state, action)
    }
}
