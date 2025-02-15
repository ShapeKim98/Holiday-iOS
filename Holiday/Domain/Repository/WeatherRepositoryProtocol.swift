//
//  WeatherRepositoryProtocol.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather(id: Int) async throws -> WeatherEntity
    func fetchWeatherGroups(id: [Int]) async throws -> [WeatherEntity]
}
