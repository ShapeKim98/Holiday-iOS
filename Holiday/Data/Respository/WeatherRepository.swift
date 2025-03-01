//
//  WeatherRepository.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let provider = NetworkProvider<WeatherEndPoint>()
    private let jsonData = JSONData.shared

    func fetchWeather(id: Int) async throws -> WeatherEntity {
        let request = WeatherRequest(id: "\(id)")
        let response: WeatherResponse = try await provider.request(.fetchWeather(request))
        
        let weatherId = response.list[0].id
        let city = try await jsonData.fetchCity(id: weatherId)
        
        return response.list[0].toEntity(
            name: city?.koCityName ?? "서울",
            country: city?.koCountryName ?? "대한민국"
        )
    }
    
    func fetchForecast(id: Int) async throws -> [ForecastEntity] {
        let request = WeatherRequest(id: "\(id)")
        let response: ForecastResponse = try await provider.request(.fetchForecast(request))
        let city = try await jsonData.fetchCity(id: id)
        return response.list.map {
            $0.toEntity(
                name: city?.koCityName ?? "서울",
                country: city?.koCountryName ?? "대한민국"
            )
        }
    }
    
    func fetchWeatherGroups(query: String?, page: Int, size: Int) async throws -> [WeatherEntity] {
        var cityData: CityData
        if let query {
            cityData = try await jsonData.fetchCityData(
                query: query,
                page: page,
                size: size
            )
        } else {
            cityData = try await jsonData.fetchCityData(page: page, size: size)
        }
        guard !cityData.cities.isEmpty else { return [] }
        
        let ids = cityData.cities.map { String($0.id) }.joined(separator: ",")
        let request = WeatherRequest(id: ids)
        let response: WeatherResponse = try await provider.request(.fetchWeather(request))
        
        return response.list.enumerated().map { index, element in
            let city = cityData.cities[index]
            return element.toEntity(
                name: city.koCityName,
                country: city.koCountryName
            )
        }
    }
}
