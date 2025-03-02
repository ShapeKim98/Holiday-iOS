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
        case bindCityId
    }
    
    struct State {
        var weather: WeatherEntity?
        var photo: PhotoEntity?
        var isLoading: Bool = true
    }
    
    @ComposableState var state = State()
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    @Shared(.userDefaults(.cityId))
    var cityId: Int? = 1835848
    
    private let useCase: CityUseCase
    
    init(useCase: CityUseCase) {
        self.useCase = useCase
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return .merge(
                fetchWeather(&state),
                .run($cityId.map { _ in Action.bindCityId } )
            )
        case let .bindWeather(weather):
            state.weather = weather
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
        case let .bindPhoto(photo):
            state.photo = photo
            state.isLoading = false
            return .none
        case .bindCityId:
            return fetchWeather(&state)
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
