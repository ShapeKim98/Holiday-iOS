//
//  ForecastResponse.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [ListItem]
}

extension ForecastResponse {
    struct ListItem: Decodable {
        let weather: [Weather]
        let main: Main
        let wind: Wind
        let dt: Date
    }
}

extension ForecastResponse.ListItem {
    func toEntity(name: String, country: String) -> ForecastEntity {
        return ForecastEntity(
            date: self.dt,
            name: name,
            country: country,
            description: self.weather.map(\.description),
            icon: self.weather.map(\.icon),
            temp: self.main.temp,
            feelsLike: self.main.feelsLike,
            tempMin: self.main.tempMin,
            tempMax: self.main.tempMax,
            humidity: self.main.humidity,
            windSpeed: self.wind.speed
        )
    }
}

extension ForecastResponse {
    static let mock = ForecastResponse(list: [
        ForecastResponse.ListItem(
            weather: [
                Weather(description: "clear sky", icon: "01n")
            ],
            main: Main(
                temp: -4.24,
                feelsLike: -10.16,
                tempMin: -4.24,
                tempMax: -3.33,
                humidity: 58.0
            ),
            wind: Wind(
                speed: 4.91
            ),
            dt: Date(timeIntervalSince1970: 1739815200)
        ),
        ForecastResponse.ListItem(
            weather: [
                Weather(description: "clear sky", icon: "01n")
            ],
            main: Main(
                temp: -4.14,
                feelsLike: -9.58,
                tempMin: -4.14,
                tempMax: -3.93,
                humidity: 48.0
            ),
            wind: Wind(
                speed: 4.27
            ),
            dt: Date(timeIntervalSince1970: 1739826000)
        ),
        ForecastResponse.ListItem(
            weather: [
                Weather(description: "clear sky", icon: "01d")
            ],
            main: Main(
                temp: -3.79,
                feelsLike: -9.58,
                tempMin: -3.79,
                tempMax: -3.57,
                humidity: 36.0
            ),
            wind: Wind(
                speed: 4.88
            ),
            dt: Date(timeIntervalSince1970: 1739836800)
        ),
        ForecastResponse.ListItem(
            weather: [
                Weather(description: "clear sky", icon: "01d")
            ],
            main: Main(
                temp: -1.59,
                feelsLike: -7.53,
                tempMin: -1.59,
                tempMax: -1.59,
                humidity: 20.0
            ),
            wind: Wind(
                speed: 6.12
            ),
            dt: Date(timeIntervalSince1970: 1739847600)
        ),
        ForecastResponse.ListItem(
            weather: [
                Weather(description: "clear sky", icon: "01d")
            ],
            main: Main(
                temp: -0.51,
                feelsLike: -6.41,
                tempMin: -0.51,
                tempMax: -0.51,
                humidity: 19.0
            ),
            wind: Wind(
                speed: 6.65
            ),
            dt: Date(timeIntervalSince1970: 1739858400)
        )
    ])
}
