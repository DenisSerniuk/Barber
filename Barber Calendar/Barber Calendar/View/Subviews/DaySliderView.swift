//
//  DayView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import SwiftUI

struct DaySliderView: View {
    
    let dayIndex: Int
    let daysOfMonth: [Date]
    private let visibleDays: CGFloat = 6
    private let itemHeight: CGFloat = 50
    private let viewHeight: CGFloat = 70
    
    var body: some View {
        GeometryReader { outerGeo in
            let itemWidth = outerGeo.size.width / visibleDays
            ScrollViewReader { scrollProxy in
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 16) {
                        ForEach(daysOfMonth.indices, id: \.self) { index in
                            GeometryReader { geo in
                                let isCentered = abs(
                                    geo.frame(in: .global).midX -
                                    outerGeo.frame(in: .global).midX
                                ) < itemWidth / 2
                                
                                Button(daysOfMonth[index].shortDayTitle().uppercased()) {
                                    withAnimation {
                                        scrollProxy.scrollTo(index,
                                                             anchor: .center)
                                    }
                                } .font(.headline)
                                    .foregroundColor(isCentered ? .white : .gray)
                                    .frame(width: itemWidth, height: itemHeight)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(isCentered ? Color.black : Color.clear)
                                            .stroke(isCentered ? Color.white : Color.clear)
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: isCentered)
                            }
                            .frame(width: itemWidth, height: itemHeight)
                        }
                    }
                }
                .onAppear {
                    scrollProxy.scrollTo(dayIndex, anchor: .center)
                }
            }
        }
        .frame(height: viewHeight)
    }
}

#Preview {
    let calendar = Calendar.current
    let today = Date()

    if let range = calendar.range(of: .day, in: .month, for: today),
       let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today)) {
        
        let days = range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: startOfMonth)
        }
        DaySliderView(dayIndex: 2, daysOfMonth: days)
    } else {
        DaySliderView(dayIndex: 2, daysOfMonth: [Date()])
    }
}
