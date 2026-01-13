//
//  DayView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import SwiftUI


struct DayView: View {
    let dayIndex: Int
    let daysOfMonth: [Date]
    @State private var offset: CGSize = .zero
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack {
            DaySliderView(dayIndex: dayIndex, daysOfMonth: daysOfMonth)
            DayTimeLineView(events: [],
                            workingHours: Date.workDay(from: 8))
            .background(.black,
                        in: RoundedRectangle(cornerRadius: 16,
                                             style: .continuous))

        }.background(Color.appBackground)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .offset(y: offset.height)
                  .gesture(
                      DragGesture()
                          .onChanged { gesture in
                              // Update offset only if moving down
                              if gesture.translation.height > 0 {
                                  offset = gesture.translation
                              }
                          }
                          .onEnded { _ in

                              if offset.height > 200 {
                                  showSheet = false
                              }
                              // Reset the offset after the gesture ends
                              offset = .zero
                          }
                  )
    }
}

#Preview {
    @Previewable @State var isShow: Bool = true
    let calendar = Calendar.current
    let today = Date()
    
    if let range = calendar.range(of: .day, in: .month, for: today),
       let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) {
        
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        DayView(dayIndex: 2, daysOfMonth: days, showSheet: $isShow)
    } else {
        DayView(dayIndex: 2, daysOfMonth: [Date()], showSheet: $isShow)
        
    }
}
