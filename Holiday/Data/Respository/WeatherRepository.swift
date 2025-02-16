//
//  WeatherRepository.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let provider = NetworkProvider<WeatherEndPoint>()
    
    @UserDefault(
        forKey: .userDefaults(.cityId),
        defaultValue: 1835848
    )
    var cityId: Int?
    
    func fetchWeather() async throws -> WeatherEntity {
        let request = WeatherRequest(id: cityId ?? 1835848)
        let response: WeatherResponse = try await provider.request(.fetchWeather(request))
        cityId = response.list[0].id
        return response.list[0].toEntity(name: "서울", country: "대한민국")
    }
    
    func fetchWeatherGroups(id: [Int]) async throws -> [WeatherEntity] {
        let response = WeatherResponse.mockWeather
        return []
    }
}
