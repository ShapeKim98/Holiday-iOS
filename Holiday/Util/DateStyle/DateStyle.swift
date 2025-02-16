//
//  DateStyle.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

enum DateStyle: String, CaseIterable {
    case d월dd일_EE_a_HH시mm분 = "M월d일(EE) a h시m분"
    case a_HH시mm분 = "a h시m분"
    
    static var cachedFormatter: [DateStyle: DateFormatter] {
        var formatters = [DateStyle: DateFormatter]()
        for style in Self.allCases {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = style.rawValue
            formatters[style] = formatter
        }
        return formatters
    }
}

extension Date {
    func toString(_ style: DateStyle) -> String {
        guard let formatter = DateStyle.cachedFormatter[style] else {
            return ""
        }
        return formatter.string(from: self)
    }
}
