//
//  PhotoRespositoryProtocol.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

protocol PhotoRepositoryProtocol {
    func fetchSearchPhoto(query: String) async throws -> PhotoEntity
}

final class TestPhotoRepository: PhotoRepositoryProtocol {
    func fetchSearchPhoto(query: String) async throws -> PhotoEntity {
        let response = PhotoResponse.mock
        return response.toEntity()
    }
}
