//
//  WeatherResponse.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

struct WeatherResponse: Decodable {
    let list: [ListItem]
}

extension WeatherResponse {
    struct ListItem: Decodable {
        let sys: Sys
        let weather: [Weather]
        let main: Main
        let wind: Wind
        let dt: Date
        let id: Int
    }
}

extension WeatherResponse.ListItem {
    struct Sys: Decodable {
        let sunrise: Date
        let sunset: Date
    }
}

extension WeatherResponse.ListItem {
    func toEntity(name: String, country: String) -> WeatherEntity {
        return WeatherEntity(
            id: self.id,
            date: self.dt,
            name: name,
            country: country,
            sunrise: self.sys.sunrise,
            sunset: self.sys.sunset,
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

extension WeatherResponse {
    static let mockWeather = WeatherResponse(list: [
        WeatherResponse.ListItem(
            sys: WeatherResponse.ListItem.Sys(
                sunrise: Date(timeIntervalSince1970: 1739571723),
                sunset: Date(timeIntervalSince1970: 1739610640)
            ),
            weather: [
                Weather(
                    description: "broken clouds",
                    icon: "04n"
                )
            ],
            main: Main(
                temp: 3,
                feelsLike: 3,
                tempMin: 3,
                tempMax: 3,
                humidity: 81
            ),
            wind: Wind(
                speed: 1.02
            ),
            dt: Date(timeIntervalSince1970: 1739621356),
            id: 1835848
        )
    ])
}
