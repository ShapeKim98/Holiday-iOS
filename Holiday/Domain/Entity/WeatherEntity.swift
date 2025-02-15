//
//  Weather.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

struct WeatherEntity {
    let id: Int
    let date: Date
    let name: String
    let country: String
    let sunrise: Date
    let sunset: Date
    let description: [String]
    let icon: [String]
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
    let windSpeed: Double
}
