//
//  BaseDTO.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation

struct Weather: Decodable {
    let description: String
    let icon: String
}

struct Main: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Double
}

struct Wind: Decodable {
    let speed: Double
}
