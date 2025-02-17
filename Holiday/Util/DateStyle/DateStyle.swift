//
//  DateStyle.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

import DGCharts

enum DateStyle: String, CaseIterable {
    case d월dd일_EE_a_HH시mm분 = "M월d일(EE) a h시m분"
    case a_HH시mm분 = "a h시m분"
    case M_d_H_m = "M/d HH:mm"
    
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

extension DateFormatter: @retroactive AxisValueFormatter {
    public func stringForValue(_ value: Double, axis: DGCharts.AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return date.toString(.M_d_H_m)
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
