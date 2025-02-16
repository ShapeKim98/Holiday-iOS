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
        view.backgroundColor = .systemBackground
    }
    func configureLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func configureCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.width, height: 100)
        
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
                }
            }
        }
    }
    
    func bindWeathers(_ weathers: [WeatherEntity]) {
        collectionView.reloadData()
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
