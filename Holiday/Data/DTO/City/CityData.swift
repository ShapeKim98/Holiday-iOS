//
//  City.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

struct CityData: Decodable {
    let cities: [City]
}

extension CityData {
    struct City: Decodable, Hashable {
        let koCityName: String
        let koCountryName: String
        let city: String
        let country: String
        let id: Int
    }
}
