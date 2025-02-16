//
//  CityViewModel.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

final class CityViewModel: ViewModel {
    enum Input {
        case viewDidLoad
        case bindWeather
        case refreshButtonTouchUpInside
    }
    
    enum Output {
        case weather(WeatherEntity?)
        case photo(PhotoEntity?)
    }
    
    struct Model {
        var weather: WeatherEntity? {
            didSet {
                guard oldValue != weather else { return }
                continuation?.yield(.weather(weather))
            }
        }
        var photo: PhotoEntity? {
            didSet {
                guard oldValue != photo else { return }
                continuation?.yield(.photo(photo))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    private(set) var model = Model()
    
    private let useCase: CityUseCase
    
    init(useCase: CityUseCase) {
        self.useCase = useCase
    }
    
    deinit { model.continuation?.finish() }
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    func input(_ action: Input) {
        switch action {
        case .viewDidLoad:
            fetchWeather()
        case .bindWeather:
            fetchPhoto()
        case .refreshButtonTouchUpInside:
            fetchWeather()
        }
    }
}

private extension CityViewModel {
    func fetchWeather() {
        self.model.weather = nil
        self.model.photo = nil
        Task { [weak self] in
            do {
                let weather = try await self?.useCase.fetchWeather(id: 1835848)
                self?.model.weather = weather
            } catch {
                
            }
        }
    }
    func fetchPhoto() {
        Task { [weak self] in
            do {
                let weather = self?.model.weather
                guard let condition = weather?.description.first else {
                    return
                }
                let photo = try await self?.useCase.fetchPhoto(condition: condition)
                self?.model.photo = photo
            }
        }
    }
}
