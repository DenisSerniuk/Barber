//
//  EventView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import SwiftUI

struct DayEvent: Identifiable {
    let id = UUID()
    let title: String
    let start: Date
    let end: Date
}

struct DayTimeLineView: View {
    @State var events: [DayEvent] = []
    let workingHours: [Date]
    
    @State private var isDragging = false
    @State private var dragLocation: CGPoint = .zero
    @State private var selectedMinutes: Int = 9 * 60
    
    private let hourHeight: CGFloat = 60
    private let minuteStep = 15
    let tapDuration: Double = 0.5
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                TimeLineView(events: events, listHours: workingHours)
                
                if isDragging {
                    BubbleView(yPosition: dragLocation.y,
                               minutes: selectedMinutes
                    )
                }
            }.contentShape(Rectangle())
                .gesture(
                    LongPressGesture(minimumDuration: tapDuration)
                        .sequenced(before: DragGesture())
                        .onChanged { value in
                            switch value {
                            case .second(true, let drag?):
                                isDragging = true
                                updateTime(from: drag.location)
                            default: break
                            }
                        }
                        .onEnded { _ in
                            isDragging = false
                            events.append(DayEvent(title: "New Appoint",
                                                   start: time(from: dragLocation),
                                                   end: time(from: dragLocation).addingTimeInterval(3600)))
                        }
                )
        }
    }
}

#Preview {
    DayTimeLineView(events: [DayEvent(title: "Meet",
                                      start: Date().addingTimeInterval((-3600*3)),
                                      end: Date().addingTimeInterval((-3600*2)))],
                    workingHours: Date.workDay(from: 8))
}

struct EventView: View {
    let event: DayEvent
    let hourHeight: CGFloat
    let timeWidth: CGFloat
    
    var body: some View {
        let start = event.start.hourAndMinute()
        let end = event.end.hourAndMinute()
        
        let startOffset =
        CGFloat(start.hour) * hourHeight +
        CGFloat(start.minute) / 60 * hourHeight
        
        let durationHours =
        CGFloat(end.hour - start.hour) +
        CGFloat(end.minute - start.minute) / 60
        
        let height = max(durationHours * hourHeight, 30)
        
        VStack(alignment: .leading) {
            Text(event.title)
                .font(.caption)
                .bold()
        }
        .padding(6)
        .background(Color.appBackground)
        .cornerRadius(8)
        .offset(
            x: timeWidth,
            y: startOffset
        )
        .frame(
            width: 400,
            height: height,
            alignment: .topLeading
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TimeLineView: View {
    let events: [DayEvent]
    let listHours: [Date]
    
    private let hourHeight: CGFloat = 60
    private let timeWidth: CGFloat = 50
    
    var body: some View {
        ScrollView {
            ZStack(alignment: .topLeading) {
                VStack(spacing: 0) {
                    ForEach(listHours,
                            id: \.self) {
                        HourView(time: $0)
                    }.frame(height: hourHeight)
                        .background(Color.clear)
                }
                
                ForEach(events) { event in
                    EventView(event: event,
                              hourHeight: hourHeight,
                              timeWidth: timeWidth)
                }
            }.padding(10)

        }.scrollDisabled(true)
    }
}

struct BubbleView: View {
    let yPosition: CGFloat
    let minutes: Int
    
    var body: some View {
        Text(timeString)
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
            )
            .foregroundColor(.white)
            .shadow(radius: 4)
            .position(x: UIScreen.main.bounds.width - 70,
                      y: yPosition)
    }
    
    private var timeString: String {
        let h = minutes / 60
        let m = minutes % 60
        return String(format: "%02d:%02d", h, m)
    }
}

extension DayTimeLineView {
    
    private func updateTime(from location: CGPoint) {
        dragLocation = location
        
        let totalMinutes = Int(location.y / hourHeight * 60)
        let snapped = snapToStep(totalMinutes)
        
        if let startHour = workingHours.first {
            selectedMinutes = min(max(snapped, 0), 23 * 60 + 45) + ((startHour.hourIndex() - 1) * 60)
        } else {
            selectedMinutes = min(max(snapped, 0), 23 * 60 + 45)
        }
    }
    
    private func time(from location: CGPoint) -> Date {
        let totalMinutes = Int(location.y / hourHeight * 60)
        return Date().startDay().addingTimeInterval(TimeInterval(totalMinutes * 60))
    }
    
    private func snapToStep(_ minutes: Int) -> Int {
        let step = minuteStep
        return (minutes / step) * step
    }
}
