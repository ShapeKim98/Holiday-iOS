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
    }
    
    enum Output {
        case weathers([WeatherEntity])
    }
    
    struct Model {
        var weathers: [WeatherEntity] = [] {
            didSet {
                guard oldValue != weathers else { return }
                continuation?.yield(.weathers(weathers))
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
            paginationCityList()
        case .tableViewWillDisplay(let row):
            guard model.weathers.count == row + 2 else { return }
            paginationCityList()
        case .tableViewPrefetchRowsAt(let rows):
            let contains = rows.contains(where: { model.weathers.count == $0 + 2 })
            guard contains else { return }
            paginationCityList()
        }
    }
}

private extension CityListViewModel {
    func paginationCityList() {
        guard !isPaging else { return }
        
        let page = self.page
        let useCase = self.useCase
        isPaging = true
        Task { [weak self] in
            defer { self?.isPaging = false }
            do {
                let response = try await useCase.fetchWeatherGroup(page: page, size: 20)
                self?.model.weathers.append(contentsOf: response)
                self?.page += 1
            } catch {
                print(error)
            }
        }
    }
}
