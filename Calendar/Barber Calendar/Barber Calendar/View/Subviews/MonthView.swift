//
//  MonthView.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 08.01.2026.
//

import SwiftUI

struct MonthView: View {
    private enum Constants {
        static let months = Calendar.current.shortMonthSymbols
        static let visibleMonths: CGFloat = 6
        static let itemHeight: CGFloat = 50
        static let viewHeight: CGFloat = 70
    }
    
    let startMonth: Int
    let currentMonth: Int
    var didSelectMonth: (Int) -> Void

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            GeometryReader { outerGeo in
                let itemWidth = outerGeo.size.width / Constants.visibleMonths
                ScrollViewReader { scrollProxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 16) {
                            ForEach(Constants.months.indices, id: \.self) { index in
                                GeometryReader { geo in
                                    let isCentered = abs(
                                        geo.frame(in: .global).midX -
                                        outerGeo.frame(in: .global).midX
                                    ) < itemWidth / 2
                                    
                                    let month = Constants.months[index]
                                    Button(month.capitalized) {
                                        if index >= (currentMonth - 1) {
                                            withAnimation {
                                                didSelectMonth(index)
                                                scrollProxy.scrollTo(index,
                                                                     anchor: .center)
                                            }
                                        }

                                    } .font(.headline)
                                        .foregroundColor(isCentered ? .white : .gray)
                                        .frame(width: itemWidth, height: Constants.itemHeight)
                                        .background(
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(isCentered ? Color.black : Color.clear)
                                                .stroke(isCentered ? Color.white : Color.clear)
                                        )
                                        .animation(.easeInOut(duration: 0.2), value: isCentered)
                                }
                                .frame(width: itemWidth,
                                       height: Constants.itemHeight)
                            }
                        }
                        .padding(.horizontal, (outerGeo.size.width - itemWidth) / 2)
                    }.onAppear {
                        scrollProxy.scrollTo((startMonth + 1))
                    }
                }
            }
            .frame(height: Constants.viewHeight)
        }
    }
}

#Preview {
    MonthView(startMonth: 5, currentMonth: 4, didSelectMonth: {_ in })
}
