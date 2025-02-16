//
//  CityListUseCase.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

final class CityListUseCase {
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchWeatherGroup(page: Int, size: Int) async throws -> [WeatherEntity] {
        try await weatherRepository.fetchWeatherGroups(page: page, size: size)
    }
}
