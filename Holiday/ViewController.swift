//
//  ViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ViewController: UIPageViewController {
    private lazy var cityViewController: CityViewController = {
        let cityUseCase = DIContainer.shared.makeCityUseCase()
        let viewModel = CityViewModel(useCase: cityUseCase)
        let viewController = CityViewController(viewModel: viewModel)
        viewController.delegate = self
        return viewController
    }()
    private lazy var forecastViewController: ForecastViewController = {
        let forecastUseCase = DIContainer.shared.makeForecastUseCase()
        let viewModel = ForecastViewModel(useCase: forecastUseCase)
        let viewController = ForecastViewController(viewModel: viewModel)
        return viewController
    }()
    private let toastMessageView = UIView()
    private let backgroundImageView = UIImageView()
    
    private let networkMonitor = NetworkMonitor()
    private var networkIsConnected = true {
        didSet { didSetNetworkIsConnected() }
    }
    
    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .vertical)
        dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = .label
        
        configureUI()
        
        setViewControllers(
            [cityViewController],
            direction: .forward,
            animated: true
        )
        
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
        configureBackgroundImageView()
        
        configureToastMessageView()
    }
    
    func configureLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        toastMessageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
    
    func configureBackgroundImageView() {
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        backgroundImageView.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
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

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard viewController is ForecastViewController else {
            return nil
        }
        return cityViewController
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard viewController is CityViewController else {
            return nil
        }
        return forecastViewController
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
    
    func updatePhotoImage(photo: PhotoEntity) {
        backgroundImageView.kf.setImage(
            with: photo.url,
            options: [.transition(.fade(0.3))]
        )
    }
    
    func bindWeather() {
        forecastViewController.bindWeather()
    }
    
    func forecastButtonTouchUpInside() {
        setViewControllers([forecastViewController], direction: .forward, animated: true)
    }
}

extension ViewController: CityListViewControllerDelegate {
    func collectionViewDidSelectItemAt(_ weather: WeatherEntity) {
        navigationItem.title = "\(weather.country), \(weather.name)"
        navigationController?.popViewController(animated: true)
        cityViewController.collectionViewDidSelectItemAt(weather)
    }
}
