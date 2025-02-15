//
//  CityUseCase.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class CityUseCase {
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchWeather(id: Int) async throws -> WeatherEntity {
        return try await weatherRepository.fetchWeather(id: id)
    }
}
