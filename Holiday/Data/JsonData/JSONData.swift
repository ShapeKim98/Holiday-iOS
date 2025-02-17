//
//  JSONData.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

final class JSONData {
    static let shared = JSONData()
    private let path = Bundle.main.path(forResource: "CityInfo", ofType: "json")
    
    private var cachedData: CityData?
    private var cachedQueryData: CityData?
    
    private init() {}
    
    private func cachingData() async throws {
        guard let path else { return }
        let jsonString = try String(contentsOfFile: path, encoding: .utf8)
        
        let data = jsonString.data(using: .utf8)
        guard let data else { return }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let cityData = try decoder.decode(CityData.self, from: data)
        cachedData = cityData
    }
    
    private func paginationCityData(cityData: CityData, page: Int, size: Int) async -> CityData {
        let startIndex = page * size
        guard startIndex < cityData.cities.count else {
            return CityData(cities: [])
        }
        let endIndex = startIndex + size
        guard endIndex < cityData.cities.count else {
            let cities = cityData.cities[startIndex..<cityData.cities.count]
            return CityData(cities: Array(cities))
        }
        let cities = cityData.cities[startIndex..<endIndex]
        return CityData(cities: Array(cities))
    }
    
    func fetchCityData(page: Int, size: Int) async throws -> CityData {
        if cachedData == nil {
            try await cachingData()
        }
        guard let cachedData else { return CityData(cities: []) }
        
        return await paginationCityData(
            cityData: cachedData,
            page: page,
            size: size
        )
    }
    
    func fetchCityData(query: String, page: Int, size: Int) async throws -> CityData {
        if page == 0 {
            cachedQueryData = cachedData
            let cities = cachedQueryData?.cities.filter { cityInfo in
                if cityInfo.koCityName.contains(query) { return true }
                if cityInfo.koCountryName.contains(query) { return true }
                let lowercasedQuery = query.lowercased()
                if cityInfo.city.lowercased().contains(lowercasedQuery) { return true }
                if cityInfo.country.lowercased().contains(lowercasedQuery) { return true }
                return false
            }
            cachedQueryData = CityData(cities: cities ?? [])
        }
        guard let cachedQueryData else { return CityData(cities: []) }
        
        return await paginationCityData(
            cityData: cachedQueryData,
            page: page,
            size: size
        )
    }
    
    func fetchCity(id: Int) async throws -> CityData.City? {
        if cachedData == nil {
            try await cachingData()
        }
        let city = cachedData?.cities.first(where: { $0.id == id })
        return city
    }
}
