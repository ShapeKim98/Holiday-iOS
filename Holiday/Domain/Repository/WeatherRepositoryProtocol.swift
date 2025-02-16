//
//  WeatherRepositoryProtocol.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather() async throws -> WeatherEntity
    func fetchWeatherGroups(id: [Int]) async throws -> [WeatherEntity]
}

final class TestWeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather() async throws -> WeatherEntity {
        let response: WeatherResponse = .mockWeather
        return response.list[0].toEntity(name: "서울", country: "대한민국")
    }
    
    func fetchWeatherGroups(id: [Int]) async throws -> [WeatherEntity] {
        let response = WeatherResponse.mockWeather
        return []
    }
}
