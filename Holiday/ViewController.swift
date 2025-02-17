//
//  ViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import UIKit

import SnapKit

final class ViewController: UIViewController {
    private lazy var cityViewController: CityViewController = {
        let cityUseCase = DIContainer.shared.makeCityUseCase()
        let viewModel = CityViewModel(useCase: cityUseCase)
        let viewController = CityViewController(viewModel: viewModel)
        viewController.delegate = self
        return viewController
    }()
    private let toastMessageView = UIView()
    
    private let networkMonitor = NetworkMonitor()
    private var networkIsConnected = true {
        didSet { didSetNetworkIsConnected() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addChild(cityViewController)
        view.addSubview(cityViewController.view)
        view.addConstraints(cityViewController.view.constraints)
        navigationController?.navigationBar.tintColor = .label
        cityViewController.didMove(toParent: self)
        
        configureUI()
        
        configureLayout()
        
        networkMonitoringStart()
    }
    
    private func networkMonitoringStart() {
        networkMonitor.monitoringStart()
        
        let publishMonitoring = networkMonitor.monitoringHandler
        Task { [weak self] in
            for await path in publishMonitoring {
                self?.networkIsConnected = path.status == .satisfied
            }
        }
    }
}

// MARK: Configure Views
private extension ViewController {
    func configureUI() {
        configureToastMessageView()
    }
    
    func configureLayout() {
        toastMessageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func configureToastMessageView() {
        let label = UILabel()
        label.text = "네트워크 연결을 확인해 주세요."
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 17, weight: .medium)
        toastMessageView.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
        
        toastMessageView.backgroundColor = .systemBackground
        toastMessageView.layer.cornerRadius = (label.font.lineHeight + 16) / 2
        toastMessageView.clipsToBounds = true
        view.addSubview(toastMessageView)
        toastMessageView.alpha = 0
        toastMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
    }
}

// MARK: Data Bindings
private extension ViewController {
    func didSetNetworkIsConnected() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            if self?.networkIsConnected ?? false {
                self?.toastMessageView.alpha = 0
                self?.toastMessageView.transform = CGAffineTransform(translationX: 0, y: 0)
            } else {
                self?.toastMessageView.alpha = 1
                self?.toastMessageView.transform = CGAffineTransform(translationX: 0, y: 50)
            }
        }
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
