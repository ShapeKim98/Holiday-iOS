//
//  PhotoRespositoryProtocol.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import RxSwift

protocol PhotoRepositoryProtocol {
    func fetchSearchPhoto(query: String) -> Single<PhotoEntity>
}

final class TestPhotoRepository: PhotoRepositoryProtocol {
    func fetchSearchPhoto(query: String) -> Single<PhotoEntity> {
        return .create { observer in
            Task {
                let response = PhotoResponse.mock
                observer(.success(response.toEntity()))
            }
            return Disposables.create()
        }
    }
}
