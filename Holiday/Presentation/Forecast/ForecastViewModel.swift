//
//  ForecastViewModel.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import Foundation

final class ForecastViewModel: ViewModel {
    enum Input {
        case viewDidLoad
        case bindWeather
    }
    
    enum Output {
        case forecasts([ForecastEntity])
    }
    
    struct Model {
        var forecasts: [ForecastEntity] = [] {
            didSet {
                continuation?.yield(.forecasts(forecasts))
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
    
    private let useCase: ForecastUseCase
    
    init(useCase: ForecastUseCase) {
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
            fetchForecasts()
        case .bindWeather:
            fetchForecasts()
        }
    }
}

private extension ForecastViewModel {
    func fetchForecasts() {
        guard let id = cityId else { return }
        let useCase = self.useCase
        Task { [weak self] in
            do {
                let response = try await useCase.fetchForecast(id: id)
                self?.model.forecasts = response
            } catch {
                print(error)
            }
        }
    }
}
