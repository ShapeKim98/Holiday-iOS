//
//  PhotoEndPoint.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import Alamofire

enum PhotoEndPoint: EndPoint, URLRequestConvertible {
    case fetchPhotos(_ model: PhotoRequest)
    
    var path: String {
        switch self {
        case .fetchPhotos: return "/search/photos"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchPhotos: return .get
        }
    }
    
    var headers: HTTPHeaders {
        return [
            "Authorization": "Client-ID \(Bundle.main.unsplashClientId)"
        ]
    }
    
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try URL(string: "https://api.unsplash.com")?
            .asURL()
            .appendingPathComponent(path)
        guard let url else { throw AFError.invalidURL(url: "https://api.unsplash.com\(path)") }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.headers = headers
        switch self {
        case let .fetchPhotos(model):
            let encoder = URLEncodedFormEncoder(keyEncoding: .convertToSnakeCase)
            request = try URLEncodedFormParameterEncoder(encoder: encoder)
                .encode(model, into: request)
        }
        
        return request
    }
}
