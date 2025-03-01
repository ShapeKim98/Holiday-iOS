//
//  CityListViewModel.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

import RxSwift
import RxCocoa

@MainActor
final class CityListViewModel: Composable {
    enum Action {
        case viewDidLoad
        case collectionViewWillDisplay(row: Int)
        case collectionViewPrefetchRowsAt(rows: [Int])
        case updateSearchResults(text: String)
        case bindWeathers([WeatherEntity])
        case bindPaginationWeathers([WeatherEntity])
        case bindQuery(String)
    }
    
    struct State {
        var weathers: [WeatherEntity] = []
        var isLoading = true
        var query: String = ""
    }
    
    @ComposableState var state = State()
    let send = PublishRelay<Action>()
    let disposeBag = DisposeBag()
    
    private var page = 0
    private var isPaging = false
    
    private let useCase: CityListUseCase
    
    init(useCase: CityListUseCase) {
        self.useCase = useCase
        bindSend()
    }
    
    func reducer(_ state: inout State, _ action: Action) -> Observable<Effect<Action>> {
        switch action {
        case .viewDidLoad:
            return fetchCityList(&state, query: state.query)
        case .collectionViewWillDisplay(let row):
            guard state.weathers.count == row + 2 else { return .none }
            return paginationCityList(&state)
        case .collectionViewPrefetchRowsAt(let rows):
            let contains = rows.contains(where: { state.weathers.count == $0 + 2 })
            guard contains else { return .none }
            return paginationCityList(&state)
        case .updateSearchResults(let text):
            guard state.query != text else { return .none }
            page = 0
            return .concatenate(
                fetchCityList(&state, query: text),
                .send(.bindQuery(text))
            )
        case let .bindWeathers(weathers):
            state.weathers = weathers
            if state.weathers.isEmpty { page += 1 }
            state.isLoading = false
            return .none
        case let .bindPaginationWeathers(weathers):
            page += 1
            state.weathers.append(contentsOf: weathers)
            if weathers.isEmpty { page += 1 }
            isPaging = false
            return .none
        case let .bindQuery(query):
            state.query = query
            return .none
        }
    }
}

private extension CityListViewModel {
    func fetchCityList(_ state: inout State, query: String) -> Observable<Effect<Action>> {
        let page = self.page
        let useCase = self.useCase
        state.isLoading = true
        
        return .run { effect in
            var response: [WeatherEntity]
            if query.isEmpty {
                response = try await useCase.fetchWeatherGroup(page: page, size: 20)
            } else {
                response = try await useCase.fetchWeatherGroup(query: query, page: page, size: 20)
            }
            effect.onNext(.send(.bindWeathers(response)))
        }
    }
    
    func paginationCityList(_ state: inout State) -> Observable<Effect<Action>> {
        guard !isPaging else { return .none }
        let page = self.page
        let useCase = self.useCase
        let query = state.query
        
        isPaging = true
        return .run { effect in
            var response: [WeatherEntity]
            if query.isEmpty {
                response = try await useCase.fetchWeatherGroup(page: page, size: 20)
            } else {
                response = try await useCase.fetchWeatherGroup(query: query, page: page, size: 20)
            }
            effect.onNext(.send(.bindPaginationWeathers(response)))
        }
    }
}
