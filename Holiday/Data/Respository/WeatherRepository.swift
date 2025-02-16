//
//  WeatherRepository.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    func fetchWeather(id: Int) async throws -> WeatherEntity {
        try await Task.sleep(nanoseconds: 1000000000)
        
        let response = WeatherResponse.mockWeather
        return response.list[0].toEntity(name: "서울", country: "대한민국")
    }
    
    func fetchWeatherGroups(id: [Int]) async throws -> [WeatherEntity] {
        let response = WeatherResponse.mockWeather
        return []
    }
}
