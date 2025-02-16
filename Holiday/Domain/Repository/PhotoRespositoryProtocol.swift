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
