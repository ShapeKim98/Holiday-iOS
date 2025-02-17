//
//  WeatherRequest.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

struct WeatherRequest: Encodable{
    let id: String
    let appid: String = Bundle.main.openweatherAppId
    let units: String = "metric"
}
