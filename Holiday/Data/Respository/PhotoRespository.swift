//
//  PhotoRespository.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

final class PhotoRepository: PhotoRepositoryProtocol {
    private let provider = NetworkProvider<PhotoEndPoint>()
    
    func fetchSearchPhoto(query: String) async throws -> PhotoEntity {
        let request = PhotoRequest(query: query)
        let response: PhotoResponse = try await provider.request(.fetchPhotos(request))
        return response.toEntity()
    }
}
