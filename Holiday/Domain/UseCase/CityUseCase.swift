//
//  CityUseCase.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class CityUseCase {
    private let weatherRepository: WeatherRepositoryProtocol
    private let photoRepository: PhotoRepositoryProtocol
    
    init(
        weatherRepository: WeatherRepositoryProtocol,
        photoRepository: PhotoRepositoryProtocol
    ) {
        self.weatherRepository = weatherRepository
        self.photoRepository = photoRepository
    }
    
    func fetchWeather() async throws -> WeatherEntity {
        return try await weatherRepository.fetchWeather()
    }
    
    func fetchWeather(id: Int) async throws -> WeatherEntity {
        return try await weatherRepository.fetchWeather(id: id)
    }
    
    func fetchPhoto(condition: String) async throws -> PhotoEntity {
        return try await photoRepository.fetchSearchPhoto(query: condition)
    }
}
