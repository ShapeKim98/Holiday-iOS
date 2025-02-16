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
    
    func fetchCityData(page: Int, size: Int) async throws -> CityData {
        if cachedData == nil {
            try await cachingData()
        }
        guard let cachedData else { return CityData(cities: []) }
        
        let startIndex = page * size
        guard startIndex < cachedData.cities.count else {
            return CityData(cities: [])
        }
        let endIndex = startIndex + size
        print(startIndex, endIndex)
        guard endIndex < cachedData.cities.count else {
            let cities = cachedData.cities[startIndex..<cachedData.cities.count]
            return CityData(cities: Array(cities))
        }
        let cities = cachedData.cities[startIndex..<endIndex]
        return CityData(cities: Array(cities))
    }
    
    func fetchCity(id: Int) async throws -> CityData.City? {
        if cachedData == nil {
            try await cachingData()
        }
        let city = cachedData?.cities.first(where: { $0.id == id })
        return city
    }
}
