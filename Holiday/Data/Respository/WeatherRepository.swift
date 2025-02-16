//
//  WeatherRepository.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let provider = NetworkProvider<WeatherEndPoint>()
    
    func fetchWeather(id: Int) async throws -> WeatherEntity {
        let request = WeatherRequest(id: id)
        let response: WeatherResponse = try await provider.request(.fetchWeather(request))
        return response.list[0].toEntity(name: "서울", country: "대한민국")
    }
    
    func fetchWeatherGroups(id: [Int]) async throws -> [WeatherEntity] {
        let response = WeatherResponse.mockWeather
        return []
    }
}
