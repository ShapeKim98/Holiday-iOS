//
//  ViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import UIKit

class ViewController: UIViewController {
    private lazy var cityViewController: CityViewController = {
        let cityUseCase = DIContainer.shared.makeCityUseCase()
        let viewModel = CityViewModel(useCase: cityUseCase)
        let viewController = CityViewController(viewModel: viewModel)
        viewController.delegate = self
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addChild(cityViewController)
        view.addSubview(cityViewController.view)
        view.addConstraints(cityViewController.view.constraints)
        navigationController?.navigationBar.tintColor = .label
        cityViewController.didMove(toParent: self)
    }


}

extension ViewController: CityViewControllerDelegate {
    func searchButtonTouchUpInside() {
        let cityListUseCase = DIContainer.shared.makeCityListUseCase()
        let viewModel = CityListViewModel(useCase: cityListUseCase)
        let viewController = CityListViewController(viewModel: viewModel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ViewController: CityListViewControllerDelegate {
    func collectionViewDidSelectItemAt(_ weather: WeatherEntity) {
        navigationItem.title = "\(weather.country), \(weather.name)"
        navigationController?.popViewController(animated: true)
        cityViewController.collectionViewDidSelectItemAt(weather)
    }
}
