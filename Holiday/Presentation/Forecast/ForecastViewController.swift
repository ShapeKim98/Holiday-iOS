//
//  ForecaseViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import DGCharts
import SnapKit
import RxSwift
import RxCocoa

final class ForecastViewController: UIViewController {
    private let lineChartView = LineChartView()
    private let tableView = UITableView()
    
    private let viewModel: ForecastViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: ForecastViewModel) {
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
        
        viewModel.send.accept(.viewDidLoad)
    }
    
    func bindWeather() {
        viewModel.send.accept(.bindWeather)
    }
}

// MARK: Configure View
private extension ForecastViewController {
    func configureUI() {
        view.backgroundColor = .clear
        
        configureLineChart()
        
        configureTableView()
    }
    
    func configureLayout() {
        lineChartView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(200)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(lineChartView.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    func configureLineChart() {
        lineChartView.backgroundColor = .clear
        lineChartView.xAxis.valueFormatter = DateStyle.cachedFormatter[DateStyle.M_d_H_m]
        lineChartView.xAxis.granularity = 86400
        lineChartView.xAxis.granularityEnabled = true
        lineChartView.xAxis.labelPosition = .bottom
        lineChartView.xAxis.drawGridLinesEnabled = false
        lineChartView.leftAxis.drawLabelsEnabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.dragEnabled = false
        
        view.addSubview(lineChartView)
    }
    
    func configureTableView() {
        tableView.backgroundColor = .clear
        tableView.register(
            ForecastTableViewCell.self,
            forCellReuseIdentifier: .forecastTableCell
        )
        let background = UIView()
        background.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 8
        blurView.clipsToBounds = true
        background.layer.cornerRadius = 8
        background.addSubview(blurView)
        tableView.backgroundView = background
        view.addSubview(tableView)
    }
}

// MARK: Data Bindings
private extension ForecastViewController {
    typealias Action = ForecastViewModel.Action
    
    func bindState() {
        let observableForecasts = viewModel.$state.driver
            .map(\.forecasts)
        
        observableForecasts
            .drive(tableView.rx.items(
                cellIdentifier: .forecastTableCell,
                cellType: ForecastTableViewCell.self
            )) { indexPath, forecast, cell in
                cell.forRowAt(forecast)
            }
            .disposed(by: disposeBag)
        
        observableForecasts
            .drive(with: self) { this, forecasts in
                this.updateForecasts(forecasts)
            }
            .disposed(by: disposeBag)
    }
    
    func updateForecasts(_ forecasts: [ForecastEntity]) {
        print(#function)
        lineChartView.data?.clearValues()
        let firstDate = forecasts.first?.date ?? .now
        let values: [ChartDataEntry] = forecasts.map { forecast in
            let timeInterval = forecast.date.timeIntervalSince(firstDate)
            
            return ChartDataEntry(x: Double(timeInterval), y: forecast.temp)
        }
        let dataSet = LineChartDataSet(entries: values, label: "온도")
        dataSet.colors = [NSUIColor.systemBlue]
        dataSet.mode = .cubicBezier
        dataSet.drawFilledEnabled = true
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.fillFormatter = DefaultFillFormatter { _, _ in
            return CGFloat(dataSet.yMin)
        }
        
        lineChartView.data = LineChartData(dataSet: dataSet)
        lineChartView.animate(xAxisDuration: 0.8, easingOption: .easeInOutCubic)
    }
}

@available(iOS 17.0, *)
#Preview {
    ForecastViewController(viewModel: ForecastViewModel(useCase: ForecastUseCase(weatherRepository: TestWeatherRepository())))
}

fileprivate extension String {
    static let forecastTableCell = "ForecastTableViewCell"
}
