//
//  CityUseCase.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

import RxSwift

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
    
    func fetchWeather(id: Int) async throws -> WeatherEntity {
        return try await weatherRepository.fetchWeather(id: id)
    }
    
    func fetchPhoto(condition: String) -> Single<PhotoEntity> {
        return photoRepository.fetchSearchPhoto(query: condition)
    }
}
