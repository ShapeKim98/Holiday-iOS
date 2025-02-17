//
//  ForecastEntity.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation

struct ForecastEntity: Equatable {
    let date: Date
    let name: String
    let country: String
    let description: [String]
    let icon: [String]
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
    let windSpeed: Double
}
