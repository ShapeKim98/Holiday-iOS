//
//  DIContainer.swift
//  Holiday
//
//  Created by 김도형 on 2/17/25.
//

import Foundation

final class DIContainer {
    static let shared = DIContainer()
    
    private init() { }
    
    private let photoRepository = PhotoRepository()
    private let weatherRepository = WeatherRepository()
    
    func makeCityUseCase() -> CityUseCase {
        return CityUseCase(
            weatherRepository: self.weatherRepository,
            photoRepository: self.photoRepository
        )
    }
    
    func makeCityListUseCase() -> CityListUseCase {
        return CityListUseCase(
            weatherRepository: self.weatherRepository
        )
    }
    
    func makeForecastUseCase() -> ForecastUseCase {
        return ForecastUseCase(
            weatherRepository: self.weatherRepository
        )
    }
}
