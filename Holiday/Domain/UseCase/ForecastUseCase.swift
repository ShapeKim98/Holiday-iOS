//
//  ForecastUseCase.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation

final class ForecastUseCase {
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchForecast(id: Int) async throws -> [ForecastEntity] {
        return try await weatherRepository.fetchForecast(id: id)
    }
}
