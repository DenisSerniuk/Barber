//
//  String+Helper.swift
//  Barber Calendar
//
//  Created by Denis Sernuk on 11.01.2026.
//

import Foundation
import UIKit

extension String {
    func toFormatedTime() -> AttributedString {
        let dayPart = 2
        let timeLength = self.count - dayPart
        let attributedText = NSMutableAttributedString(string: self)
        attributedText.addAttributes([.foregroundColor: UIColor.textSecondary,
                                      .font: UIFont.preferredFont(forTextStyle: .caption2)],
                                     range: NSMakeRange(timeLength,dayPart))
        attributedText.addAttributes([.foregroundColor: UIColor.textPrimary,
                                      .font: UIFont.preferredFont(forTextStyle: .title3)],
                                     range: NSMakeRange(0, timeLength))
        return AttributedString(attributedText)
        
    }
}
