//
//  CityListViewModel.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import Foundation

final class CityListViewModel: ViewModel {
    enum Input {
        case viewDidLoad
        case tableViewWillDisplay(row: Int)
        case tableViewPrefetchRowsAt(rows: [Int])
        case updateSearchResults(text: String?)
    }
    
    enum Output {
        case weathers([WeatherEntity])
        case isLoading(Bool)
        case query(String)
    }
    
    struct Model {
        var weathers: [WeatherEntity] = [] {
            didSet {
                guard oldValue != weathers else { return }
                continuation?.yield(.weathers(weathers))
            }
        }
        var isLoading = true {
            didSet {
                guard oldValue != isLoading else { return }
                continuation?.yield(.isLoading(isLoading))
            }
        }
        var query: String = "" {
            didSet {
                guard oldValue != query else { return }
                continuation?.yield(.query(query))
            }
        }
        
        fileprivate var continuation: AsyncStream<Output>.Continuation?
    }
    
    private(set) var model = Model()
    private var page = 0
    private var isPaging = false
    
    private let useCase: CityListUseCase
    
    init(useCase: CityListUseCase) {
        self.useCase = useCase
    }
    
    var output: AsyncStream<Output> {
        return AsyncStream { continuation in
            model.continuation = continuation
        }
    }
    
    deinit { model.continuation?.finish() }
    
    func input(_ action: Input) {
        switch action {
        case .viewDidLoad:
            fetchCityList()
        case .tableViewWillDisplay(let row):
            guard model.weathers.count == row + 2 else { return }
            paginationCityList()
        case .tableViewPrefetchRowsAt(let rows):
            let contains = rows.contains(where: { model.weathers.count == $0 + 2 })
            guard contains else { return }
            paginationCityList()
        case .updateSearchResults(text: let text):
            guard let text, model.query != text else { return }
            page = 0
            model.query = text
            fetchCityList()
        }
    }
}

private extension CityListViewModel {
    func fetchCityList() {
        let page = self.page
        let useCase = self.useCase
        let query = self.model.query
        
        Task { [weak self] in
            self?.model.isLoading = true
            defer { self?.model.isLoading = false }
            do {
                var response: [WeatherEntity]
                if query.isEmpty {
                    response = try await useCase.fetchWeatherGroup(page: page, size: 20)
                } else {
                    response = try await useCase.fetchWeatherGroup(query: query, page: page, size: 20)
                }
                self?.model.weathers = response
                guard !response.isEmpty else { return }
                self?.page += 1
            } catch {
                print(error)
            }
        }
    }
    
    func paginationCityList() {
        guard !isPaging else { return }
        let page = self.page
        let useCase = self.useCase
        let query = self.model.query
        
        isPaging = true
        Task { [weak self] in
            defer { self?.isPaging = false }
            do {
                var response: [WeatherEntity]
                if query.isEmpty {
                    response = try await useCase.fetchWeatherGroup(page: page, size: 20)
                } else {
                    response = try await useCase.fetchWeatherGroup(query: query, page: page, size: 20)
                }
                self?.model.weathers.append(contentsOf: response)
                guard !response.isEmpty else { return }
                self?.page += 1
            } catch {
                print(error)
            }
        }
    }
}
