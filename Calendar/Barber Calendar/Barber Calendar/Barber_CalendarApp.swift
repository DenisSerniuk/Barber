//
//  Barber_CalendarApp.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 08.01.2026.
//

import SwiftUI

@main
struct Barber_CalendarApp: App {
    var body: some Scene {
        let store = Store(state: AppState(), reducer: reducer)
        WindowGroup {
            ContentView().environmentObject(store)
        }
    }
}
