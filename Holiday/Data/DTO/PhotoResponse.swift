//
//  PhotoResponse.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

struct PhotoResponse: Decodable {
    let results: [Result]
}

extension PhotoResponse {
    struct Result: Decodable {
        let urls: [URLs]
        let width: Int
        let height: Int
    }
}

extension PhotoResponse.Result {
    struct URLs: Decodable {
        let small: String
    }
}

extension PhotoResponse {
    func toEntity() -> PhotoEntity {
        let result = self.results.first
        let url = result?.urls.first?.small ?? ""
        return PhotoEntity(
            url: URL(string: url),
            width: result?.width ?? 0,
            height: result?.height ?? 0
        )
    }
}

extension PhotoResponse {
    static let mock = PhotoResponse(results: [
        PhotoResponse.Result(
            urls: [ PhotoResponse.Result.URLs(small: "https://images.unsplash.com/photo-1621859178739-c8dc945b556e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2OTg2MTN8MHwxfHNlYXJjaHwxfHxicm9rZW4lMjBjbG91ZHN8ZW58MHx8fHwxNzM5NjI3MTM5fDA&ixlib=rb-4.0.3&q=80&w=400")],
            width: 4000,
            height: 3000
        )
    ])
}
