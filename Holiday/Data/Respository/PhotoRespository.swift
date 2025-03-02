//
//  PhotoRespository.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import RxSwift

final class PhotoRepository: PhotoRepositoryProtocol {
    private let provider = NetworkProvider<PhotoEndPoint>()
    
    func fetchSearchPhoto(query: String) -> Single<PhotoEntity> {
        let request = PhotoRequest(query: query)
        let provider = self.provider
        
        return .create { observer in
            Task {
                do {
                    let response: PhotoResponse = try await provider.request(.fetchPhotos(request))
                    observer(.success(response.toEntity()))
                } catch {
                    observer(.failure(error))
                }
            }
            return Disposables.create()
        }
    }
}
