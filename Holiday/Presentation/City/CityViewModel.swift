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
        case collectionViewDidSelectItemAt(_ weather: WeatherEntity)
    }
    
    enum Output {
        case weather(WeatherEntity?)
        case photo(PhotoEntity?)
        case isLoading(Bool)
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
        var isLoading: Bool = true {
            didSet {
                guard oldValue != isLoading else { return }
                continuation?.yield(.isLoading(isLoading))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    private(set) var model = Model()
    
    @UserDefault(
        forKey: .userDefaults(.cityId),
        defaultValue: 1835848
    )
    var cityId: Int?
    
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
        case let .collectionViewDidSelectItemAt(weather):
            self.model.weather = weather
            self.cityId = weather.id
        }
    }
}

private extension CityViewModel {
    func fetchWeather() {
        guard let id = cityId else { return }
        Task { [weak self] in
            self?.model.isLoading = true
            defer { self?.model.isLoading = false }
            do {
                let weather = try await self?.useCase.fetchWeather(id: id)
                self?.model.weather = weather
                self?.cityId = weather?.id
            } catch {
                print(error)
            }
        }
    }
    func fetchPhoto() {
        Task { [weak self] in
            self?.model.isLoading = true
            defer { self?.model.isLoading = false }
            do {
                let weather = self?.model.weather
                guard let condition = weather?.description.first else {
                    return
                }
                let photo = try await self?.useCase.fetchPhoto(condition: condition)
                self?.model.photo = photo
            } catch {
                print(error)
            }
        }
    }
}
