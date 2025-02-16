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
        let request = try endPoint.asURLRequest()
        print("[ℹ️] NETWORK -> request:")
        print("""
        method: \(request.httpMethod ?? ""),
        url: \(request.url?.absoluteString ?? ""),
        """
        )
        print("headers: ", terminator: "")
        print("[")
        for header in request.allHTTPHeaderFields ?? [:] {
            print("  \(header.key): \(header.value),")
        }
        print("],\n")
        if let body = request.httpBody {
            let data: Data = try JSONSerialization.data(
                withJSONObject: body,
                options: [.prettyPrinted]
            )
            print("body: \(String(data: data, encoding: .utf8) ?? "nil")")
        }
#endif
        let response = await AF.request(endPoint)
        .validate(statusCode: 200..<300)
        .serializingDecodable(T.self, decoder: endPoint.decoder)
        .response
        
#if DEBUG
        print("[ℹ️] NETWORK -> response:")
        if let urlResponse = response.response {
            print("url: \(urlResponse.url?.absoluteString ?? "N/A"),")
            print("status code: \(urlResponse.statusCode),")
            print("headers: ", terminator: "")
            let headers = urlResponse.allHeaderFields as? [String: String]
            print("[")
            for header in headers ?? [:] {
                print("  \(header.key): \(header.value),")
            }
            print("],")
        } else {
            print(String(describing: response.response))
        }
        if let data = response.data {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            
            print("body: \(String(data: jsonData, encoding: .utf8) ?? "nil")")
        }
#endif
        
        switch response.result {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
