//
//  NetworkProvider.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import Alamofire

struct NetworkProvider<E: URLRequestConvertible & EndPoint>: Sendable {
    func request<T: Decodable>(_ endPoint: E) async throws -> T {
#if DEBUG
//        try NetworkLogger.request(endPoint)
#endif
        let response = await AF.request(endPoint)
        .validate(statusCode: 200..<300)
        .serializingDecodable(T.self, decoder: endPoint.decoder)
        .response
        
#if DEBUG
//        try NetworkLogger.response(response)
#endif
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
