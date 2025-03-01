//
//  CityViewModel.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class CityViewModel: Composable {
    enum Action {
        case viewDidLoad
        case bindWeather(WeatherEntity)
        case bindPhoto(PhotoEntity)
        case refreshButtonTouchUpInside
        case collectionViewDidSelectItemAt(_ weather: WeatherEntity)
    }
    
    struct State {
        var weather: WeatherEntity?
        var photo: PhotoEntity?
        var isLoading: Bool = true
    }
    
    @ComposableState var state = State()
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    @UserDefault(
        forKey: .userDefaults(.cityId),
        defaultValue: 1835848
    )
    var cityId: Int?
    
    private let useCase: CityUseCase
    
    init(useCase: CityUseCase) {
        self.useCase = useCase
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return fetchWeather(&state)
        case let .bindWeather(weather):
            state.weather = weather
            self.cityId = weather.id
            return .run { [weak self] effect in
                guard let self else { return }
                guard let condition = weather.description.first else {
                    return
                }
                let photo = try await useCase.fetchPhoto(condition: condition)
                effect.onNext(.send(.bindPhoto(photo)))
            }
        case .refreshButtonTouchUpInside:
            return fetchWeather(&state)
        case let .collectionViewDidSelectItemAt(weather):
            state.isLoading = true
            return .send(.bindWeather(weather))
        case let .bindPhoto(photo):
            state.photo = photo
            state.isLoading = false
            return .none
        }
    }
}

private extension CityViewModel {
    func fetchWeather(_ state: inout State) -> Observable<Effect<Action>> {
        guard let id = cityId else { return .none }
        state.isLoading = true
        let useCase = self.useCase
        return .run { effect in
            let weather = try await useCase.fetchWeather(id: id)
            effect.onNext(.send(.bindWeather(weather)))
        }
    }
}
