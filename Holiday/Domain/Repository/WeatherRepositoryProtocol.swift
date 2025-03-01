//
//  WeatherRepositoryProtocol.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

protocol WeatherRepositoryProtocol {
    func fetchWeather(id: Int) async throws -> WeatherEntity
    func fetchWeatherGroups(query: String?, page: Int, size: Int) async throws -> [WeatherEntity]
    func fetchForecast(id: Int) async throws -> [ForecastEntity]
}

final class TestWeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather(id: Int) async throws -> WeatherEntity {
        let response: WeatherResponse = .mockWeather
        return response.list[0].toEntity(name: "서울", country: "대한민국")
    }
    
    func fetchWeatherGroups(query: String?, page: Int, size: Int) async throws -> [WeatherEntity] {
        return []
    }
    
    func fetchForecast(id: Int) async throws -> [ForecastEntity] {
//        let response = ForecastResponse.mockForcast
//        return response.list.map { $0.toEntity(name: "서울", country: "대한민국") }
        return []
    }
}
