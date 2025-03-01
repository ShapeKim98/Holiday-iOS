//
//  CityListViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa

protocol CityListViewControllerDelegate: AnyObject {
    func collectionViewDidSelectItemAt(_ weather: WeatherEntity)
}

final class CityListViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        return configureCollectionView()
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    private let searchController = UISearchController()
    
    private let viewModel: CityListViewModel
    private let disposeBag = DisposeBag()
    
    weak var delegate: CityListViewControllerDelegate?
    
    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        configureLayout()
        
        bindState()
        
        bindAction()
        
        viewModel.send.accept(.viewDidLoad)
    }
}

// MARK: Configure Views
private extension CityListViewController {
    func configureUI() {
        view.backgroundColor = .systemGray6
        
        navigationItem.largeTitleDisplayMode = .never
        
        configureSearchController()
        
        configureActivityIndicatorView()
        
        configureEmptyLabel()
    }
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width - 40, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(
            CityCollectionViewCell.self,
            forCellWithReuseIdentifier: .cityCollectionCell
        )
        collectionView.keyboardDismissMode = .onDrag
        
        view.addSubview(collectionView)
        return collectionView
    }
    
    func configureSearchController() {
        searchController.searchBar.placeholder = "지금, 날씨가 궁금한 곳은?"
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    func configureActivityIndicatorView() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    func configureEmptyLabel() {
        emptyLabel.text = "원하는 도시를 찾지 못했습니다."
        emptyLabel.font = .systemFont(ofSize: 17, weight: .medium)
        emptyLabel.textColor = .secondaryLabel
        emptyLabel.isHidden = true
        view.addSubview(emptyLabel)
    }
}

// MARK: Data Bindins
private extension CityListViewController {
    typealias Action = CityListViewModel.Action
    
    func bindAction() {
        collectionView.rx.prefetchItems
            .map { Action.collectionViewPrefetchRowsAt(rows: $0.map(\.row)) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell
            .map { Action.collectionViewWillDisplay(row: $0.at.row) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(WeatherEntity.self)
            .bind(with: self) { this, weather in
                this.delegate?.collectionViewDidSelectItemAt(weather)
            }
            .disposed(by: disposeBag)
        
        searchController.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .map { Action.updateSearchResults(text: $0) }
            .bind(to: viewModel.send)
            .disposed(by: disposeBag)
    }
    
    func bindState() {
        bindWeathers()
        
        bindQuery()
        
        bindIsLoading()
    }
    
    func bindWeathers() {
        let observableWeathers = viewModel.$state.driver
            .map(\.weathers)
            .distinctUntilChanged()
        
        observableWeathers
            .drive(collectionView.rx.items(
                cellIdentifier: .cityCollectionCell,
                cellType: CityCollectionViewCell.self
            )) { indexPath, weather, cell in
                cell.forRowAt(weather)
            }
            .disposed(by: disposeBag)
        
        observableWeathers
            .map(\.isEmpty)
            .drive(with: self) { this, isEmpty in
                UIView.animate(withDuration: 0.3) {
                    this.emptyLabel.alpha = isEmpty ? 1 : 0
                } completion: { _ in
                    this.emptyLabel.isHidden = !isEmpty
                }
            }
            .disposed(by: disposeBag)
    }
    
    func bindQuery() {
        viewModel.$state.driver
            .map(\.query)
            .distinctUntilChanged()
            .map { _ in true }
            .drive(collectionView.rx.scrollsToTop)
            .disposed(by: disposeBag)
    }
    
    func bindIsLoading() {
        viewModel.$state.driver
            .map(\.isLoading)
            .distinctUntilChanged()
            .drive(with: self) { this, isLoading in
                UIView.animate(withDuration: 0.3) {
                    this.activityIndicatorView.alpha = isLoading ? 1 : 0
                } completion: { _ in
                    if isLoading {
                        this.activityIndicatorView.startAnimating()
                    } else {
                        this.activityIndicatorView.stopAnimating()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}

fileprivate extension String {
    static let cityCollectionCell = "CityCollectionViewCell"
}
