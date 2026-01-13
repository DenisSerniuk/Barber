//
//  HourView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import SwiftUI

struct Reservation {
    var image: UIImage?
    var name: String
    var duration: Double
}

struct HourView: View {
    let time: Date
    var body: some View {
        HStack() {
            Text(time.toTime().toFormatedTime())
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
        }
    }
}

#Preview {
    HourView(time: Date())
}
