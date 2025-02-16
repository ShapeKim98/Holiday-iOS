//
//  WeatherEndPoint.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import Alamofire

enum WeatherEndPoint: EndPoint, URLRequestConvertible {
    case fetchWeather(_ model: WeatherRequest)
    
    var path: String {
        switch self {
        case .fetchWeather: return "/group"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchWeather: return .get
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: "https://api.openweathermap.org/data/2.5")?
            .asURL()
            .appendingPathComponent(path)
        guard let url else { throw AFError.invalidURL(url: "https://api.openweathermap.org/data/2.5/\(path)") }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        switch self {
        case let .fetchWeather(model):
            request = try URLEncodedFormParameterEncoder().encode(model, into: request)
        }
        
        return request
    }
}
