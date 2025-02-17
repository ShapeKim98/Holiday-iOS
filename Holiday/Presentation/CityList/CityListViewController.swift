//
//  CityListViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import UIKit

import SnapKit

final class CityListViewController: UIViewController {
    private let viewModel: CityListViewModel
    private lazy var collectionView: UICollectionView = {
        return configureCollectionView()
    }()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let emptyLabel = UILabel()
    
    init(viewModel: CityListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataBinding()
        
        configureUI()
        
        configureLayout()
        
        viewModel.input(.viewDidLoad)
    }
}

// MARK: Configure Views
private extension CityListViewController {
    func configureUI() {
        view.backgroundColor = .systemGray6
        
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
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
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
        let searchController = UISearchController()
        searchController.searchBar.placeholder = "지금, 날씨가 궁금한 곳은?"
        searchController.searchResultsUpdater = self
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
    func dataBinding() {
        let outputPublisher = viewModel.output
        Task { [weak self] in
            for await output in outputPublisher {
                switch output {
                case let .weathers(weathers):
                    self?.bindWeathers(weathers)
                case let .isLoading(isLoading):
                    self?.bindIsLoading(isLoading)
                case let .query(query):
                    self?.bindQuery(query)
                }
            }
        }
    }
    
    func bindWeathers(_ weathers: [WeatherEntity]) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.emptyLabel.alpha = weathers.isEmpty ? 1 : 0
        } completion: { [weak self] _ in
            self?.emptyLabel.isHidden = !weathers.isEmpty
        }
        collectionView.reloadData()
    }
    
    func bindIsLoading(_ isLoading: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.activityIndicatorView.alpha = isLoading ? 1 : 0
        } completion: { [weak self] _ in
            if isLoading {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
    
    func bindQuery(_ query: String) {
        if !viewModel.model.weathers.isEmpty {
            let firstIndex = IndexPath(item: 0, section: 0)
            collectionView.scrollToItem(at: firstIndex, at: .top, animated: false)
        }
    }
}

extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text
        viewModel.input(.updateSearchResults(text: text))
    }
}

extension CityListViewController: UICollectionViewDelegate,
                                  UICollectionViewDataSource,
                                  UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.model.weathers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: .cityCollectionCell,
            for: indexPath
        ) as? CityCollectionViewCell
        guard let cell else { return UICollectionViewCell() }
        let weather = viewModel.model.weathers[indexPath.row]
        cell.forRowAt(weather)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        viewModel.input(.tableViewPrefetchRowsAt(rows: indexPaths.map(\.item)))
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.input(.tableViewWillDisplay(row: indexPath.item))
    }
}

fileprivate extension String {
    static let cityCollectionCell = "CityCollectionViewCell"
}
