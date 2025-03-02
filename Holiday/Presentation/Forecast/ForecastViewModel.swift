//
//  ForecastViewModel.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation

import RxSwift
import RxCocoa

final class ForecastViewModel: Composable {
    enum Action {
        case viewDidLoad
        case bindWeather
        case bindForecasts([ForecastEntity])
    }
    
    struct State {
        var forecasts: [ForecastEntity] = []
    }
    
    @ComposableState var state = State()
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    @Shared(.userDefaults(.cityId))
    var cityId: Int?
    
    private let useCase: ForecastUseCase
    
    init(useCase: ForecastUseCase) {
        self.useCase = useCase
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return .merge(
                fetchForecasts(),
                .run($cityId.map { _ in Action.bindWeather })
            )
        case .bindWeather:
            return fetchForecasts()
        case let .bindForecasts(forecasts):
            state.forecasts = forecasts
            return .none
        }
    }
}

private extension ForecastViewModel {
    func fetchForecasts() -> Observable<Effect<Action>> {
        guard let id = cityId else { return .none }
        let useCase = self.useCase
        
        return .run { effect in
            let response = try await useCase.fetchForecast(id: id)
            effect.onNext(.send(.bindForecasts(response)))
        }
    }
}
