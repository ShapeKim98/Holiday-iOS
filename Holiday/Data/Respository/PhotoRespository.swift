//
//  PhotoRespository.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

final class PhotoRepository: PhotoRepositoryProtocol {
    func fetchSearchPhoto(query: String) async throws -> PhotoEntity {
        let response = PhotoResponse.mock
        return response.toEntity()
    }
}
