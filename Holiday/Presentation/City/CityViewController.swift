//
//  CityViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import UIKit

import Kingfisher
import SnapKit

final class CityViewController: UIViewController {
    private let dateLabel = UILabel()
    private let weatherVStack = UIStackView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private var weatherLabels: [UIView] = []
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let viewModel: CityViewModel
    
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        dataBinding()
        
        configureUI()
        
        configureLayout()
        
        viewModel.input(.viewDidLoad)
    }
}

// MARK: Configure Views
private extension CityViewController {
    func configureUI() {
        configureScrollView()
        
        configureContentView()
        
        configureDateLabel(date: .now)
        
        configureWeatherVStack()
    }
    
    func configureLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(view).inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        weatherVStack.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        for label in weatherLabels {
            label.snp.makeConstraints { make in
                make.leading.equalToSuperview()
            }
        }
    }
    
    func configureScrollView() {
        view.addSubview(scrollView)
    }
    
    func configureContentView() {
        scrollView.addSubview(contentView)
    }
    
    func configureDateLabel(date: Date) {
        dateLabel.text = date.toString(.d월dd일_EE_a_HH시mm분)
        dateLabel.font = .systemFont(ofSize: 16, weight: .bold)
        dateLabel.textColor = .label
        contentView.addSubview(dateLabel)
    }
    
    func configureWeatherVStack() {
        weatherVStack.axis = .vertical
        weatherVStack.distribution = .fill
        weatherVStack.alignment = .leading
        weatherVStack.spacing = 8
        contentView.addSubview(weatherVStack)
    }
    
    func configureWeatherConditionLabel(iconName: String, condition: String) {
        let background = configureWeatherLabelBackground()
        
        let icon = UIImageView()
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")
        icon.kf.setImage(with: url)
        background.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview().inset(12)
        }
        
        let description = NSAttributedString(
            string: "오늘의 날씨는 \(condition) 입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: condition
        )
        let label = UILabel()
        label.attributedText = description
        label.textColor = .label
        background.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(icon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(16)
            make.centerY.equalTo(icon)
        }
        weatherVStack.addArrangedSubview(background)
        weatherLabels.append(background)
    }
    
    func configureWeatherTempLabel(temp: Double, tempMin: Double, tempMax: Double) {
        let background = configureWeatherLabelBackground()
        let label = UILabel()
        let temp = String(format: "%.1f°", temp)
        label.attributedText = NSAttributedString(
            string: "현재 온도는 \(temp) 입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: temp
        )
        background.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(16)
        }
        
        let tempMin = String(format: "%.1f°C", tempMin)
        let tempMax = String(format: "%.1f°C", tempMax)
        let minMaxLabel = UILabel()
        minMaxLabel.text = "최저\(tempMin) 최고\(tempMax)"
        minMaxLabel.font = .systemFont(ofSize: 14)
        minMaxLabel.textColor = .secondaryLabel
        background.addSubview(minMaxLabel)
        minMaxLabel.snp.makeConstraints { make in
            make.leading.equalTo(label.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(label.snp.bottom)
        }
        weatherVStack.addArrangedSubview(background)
        weatherLabels.append(background)
    }
    
    func configureWeatherFeelsLikeLabel(feelsLike: Double) {
        let feelsLike = String(format: "%.1f°", feelsLike)
        let text = NSAttributedString(
            string: "체감 온도는 \(feelsLike)입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: feelsLike
        )
        let label = configureWeatherLabel(text: text)
        weatherVStack.addArrangedSubview(label)
        weatherLabels.append(label)
    }
    
    func configureWeatherSunTimeLabel(sunrise: Date, sunset: Date) {
        let sunrise = (sunrise).toString(.a_HH시mm분)
        let sunset = (sunset).toString(.a_HH시mm분)
        let text = NSAttributedString(
            string: "서울의 일출 시각은 \(sunrise), 일몰 시각은 \(sunset) 입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: sunrise, sunset
        )
        let label = configureWeatherLabel(text: text)
        weatherVStack.addArrangedSubview(label)
        weatherLabels.append(label)
    }
    
    func configureWeatherHumidityWindLabel(humidity: Double, wind: Double) {
        let humidity = "\(humidity)%"
        let wind = String(format: "%.2fm/s", wind)
        let text = NSAttributedString(
            string: "습도는 \(humidity) 이고, 풍속은 \(wind)입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: humidity, wind
        )
        let label = configureWeatherLabel(text: text)
        weatherVStack.addArrangedSubview(label)
        weatherLabels.append(label)
    }
    
    func configureWeatherLabel(text: NSAttributedString, lines: Int = 0) -> UIView {
        let background = configureWeatherLabelBackground()
        let label = UILabel()
        label.attributedText = text
        background.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
        label.numberOfLines = lines
        return background
    }
    
    func configureWeatherPhoto(photo: PhotoEntity) {
        let background = configureWeatherLabelBackground()
        let label = UILabel()
        label.text = "오늘의 사진"
        label.font = .systemFont(ofSize: 16)
        background.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
        }
        let image = UIImageView()
        image.kf.setImage(with: photo.url)
        background.addSubview(image)
        image.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
            make.height.equalTo(image.snp.width).multipliedBy(photo.width / photo.height)
        }
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        weatherVStack.addArrangedSubview(background)
        weatherLabels.append(background)
    }
    
    func configureWeatherLabelBackground() -> UIView {
        let background = UIView()
        background.backgroundColor = .white
        background.layer.cornerRadius = 8
        return background
    }
    
    func configureNavigationTitle(_ title: String) {
        navigationItem.title = title
    }
}

// MARK: Data Bindings
private extension CityViewController {
    func dataBinding() {
        let outputPublisher = viewModel.output
        Task { [weak self] in
            for await output in outputPublisher {
                switch output {
                case let .weather(weather):
                    self?.bindWeather(weather)
                case let .photo(photo):
                    self?.bindPhoto(photo)
                }
            }
        }
    }
    
    func bindWeather(_ weather: WeatherEntity?) {
        for label in weatherLabels {
            weatherVStack.removeArrangedSubview(label)
            label.removeFromSuperview()
        }
        weatherLabels.removeAll()
        
        guard let weather else { return }
        
        configureNavigationTitle("\(weather.country), \(weather.name)")
        
        configureDateLabel(date: weather.date)
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        configureWeatherConditionLabel(
            iconName: weather.icon.first ?? "",
            condition: weather.description.first ?? ""
        )
        
        configureWeatherTempLabel(
            temp: weather.temp,
            tempMin: weather.tempMin,
            tempMax: weather.tempMax
        )
        
        configureWeatherFeelsLikeLabel(feelsLike: weather.feelsLike)
        
        configureWeatherSunTimeLabel(
            sunrise: weather.sunrise,
            sunset: weather.sunset
        )
        
        configureWeatherHumidityWindLabel(
            humidity: weather.humidity,
            wind: weather.windSpeed
        )
        
        for label in weatherLabels {
            label.snp.makeConstraints { make in
                make.leading.equalToSuperview()
            }
        }
        
        viewModel.input(.bindWeather)
    }
    
    func bindPhoto(_ photo: PhotoEntity?) {
        guard let photo else { return }
        
        configureWeatherPhoto(photo: photo)
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: CityViewController(viewModel: CityViewModel(useCase: CityUseCase(
        weatherRepository: WeatherRepository(),
        photoRepository: PhotoRepository()
    ))))
    
}
