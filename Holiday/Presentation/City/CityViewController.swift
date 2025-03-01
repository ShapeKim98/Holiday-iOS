//
//  CityViewController.swift
//  Holiday
//
//  Created by 김도형 on 2/15/25.
//

import UIKit

import Kingfisher
import SnapKit

protocol CityViewControllerDelegate: AnyObject {
    func searchButtonTouchUpInside()
    func updatePhotoImage(photo: PhotoEntity)
    func bindWeather()
    func forecastButtonTouchUpInside()
}

final class CityViewController: UIViewController {
    private let dateLabel = UILabel()
    private let weatherVStack = UIStackView()
    private let activityIndicatorView = UIActivityIndicatorView(style: .large)
    private let conditionIcon = UIImageView()
    private let conditionLabel = UILabel()
    private let tempLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    private let sunTimeLabel = UILabel()
    private let humidityWindLabel = UILabel()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let photoImageView = UIImageView()
    private let todayPhotoLabel = UILabel()
    private let forecastButton = UIButton()
    
    private let viewModel: CityViewModel
    
    weak var delegate: CityViewControllerDelegate?
    
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        configureNavigation()
        
        dataBinding()
        
        configureUI()
        
        configureLayout()
        
        viewModel.input(.viewDidLoad)
    }
    
    func collectionViewDidSelectItemAt(_ weather: WeatherEntity) {
        viewModel.input(.collectionViewDidSelectItemAt(weather))
    }
}

// MARK: Configure Views
private extension CityViewController {
    func configureUI() {
        configureScrollView()
        
        configureContentView()
        
        configureDateLabel(date: .now)
        
        configureWeatherVStack()
        
        configureActivityIndicatorView()
        
        configureWeatherConditionLabel()
        
        configureWeatherTempLabel()
        
        configureWeatherFeelsLikeLabel()
        
        configureWeatherSunTimeLabel()
        
        configureWeatherHumidityWindLabel()
        
        configureWeatherPhoto()
        
        configureForecastButton()
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
        }
        
        forecastButton.snp.makeConstraints { make in
            make.top.equalTo(weatherVStack.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        weatherVStack.subviews.forEach { view in
            view.snp.makeConstraints { make in
                make.leading.equalToSuperview()
            }
        }
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func configureNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.topItem?.rightBarButtonItems = [
            UIBarButtonItem(
                systemItem: .search,
                primaryAction: UIAction { [weak self] _ in
                    self?.searchButtonTouchUpInside()
                }
            ),
            UIBarButtonItem(
                systemItem: .refresh,
                primaryAction: UIAction { [weak self] _ in
                    self?.refreshButtonTouchUpInside()
                }
            )
        ]
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
    
    func configureWeatherConditionLabel() {
        let background = configureWeatherLabelBackground()
        conditionIcon.contentMode = .scaleAspectFill
        background.addSubview(conditionIcon)
        conditionIcon.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview().inset(12)
        }
        
        conditionLabel.textColor = .label
        background.addSubview(conditionLabel)
        conditionLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionIcon.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(16)
            make.centerY.equalTo(conditionIcon)
        }
        weatherVStack.addArrangedSubview(background)
    }
    
    func configureWeatherTempLabel() {
        let background = configureWeatherLabelBackground()
        
        background.addSubview(tempLabel)
        tempLabel.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview().inset(16)
        }
        
        minMaxTempLabel.font = .systemFont(ofSize: 14)
        minMaxTempLabel.textColor = .secondaryLabel
        background.addSubview(minMaxTempLabel)
        minMaxTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(tempLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalTo(tempLabel.snp.bottom)
        }
        weatherVStack.addArrangedSubview(background)
    }
    
    func configureWeatherFeelsLikeLabel() {
        configureWeatherLabel(label: feelsLikeLabel)
    }
    
    func configureWeatherSunTimeLabel() {
        configureWeatherLabel(label: sunTimeLabel)
    }
    
    func configureWeatherHumidityWindLabel() {
        configureWeatherLabel(label: humidityWindLabel)
    }
    
    func configureWeatherLabel(label: UILabel, lines: Int = 0) {
        let background = configureWeatherLabelBackground()
        background.addSubview(label)
        label.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
        label.numberOfLines = lines
        weatherVStack.addArrangedSubview(background)
    }
    
    func configureWeatherPhoto() {
        let background = configureWeatherLabelBackground()
        todayPhotoLabel.text = "오늘의 사진"
        todayPhotoLabel.font = .systemFont(ofSize: 16)
        background.addSubview(todayPhotoLabel)
        todayPhotoLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(12)
        }
        background.addSubview(photoImageView)
        photoImageView.layer.cornerRadius = 8
        photoImageView.clipsToBounds = true
        weatherVStack.addArrangedSubview(background)
    }
    
    func configureForecastButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "chevron.down")
        configuration.title = "5일간 예보 보러가기"
        configuration.imagePlacement = .leading
        configuration.imagePadding = 8
        forecastButton.configuration = configuration
        forecastButton.tintColor = .label
        forecastButton.addAction(
            UIAction { [weak self] _ in
                self?.delegate?.forecastButtonTouchUpInside()
            },
            for: .touchUpInside
        )
        contentView.addSubview(forecastButton)
    }
    
    func configureWeatherLabelBackground() -> UIView {
        let background = UIView()
        background.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .systemThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = 8
        blurView.clipsToBounds = true
        background.layer.cornerRadius = 8
        background.addSubview(blurView)
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return background
    }
    
    func configureNavigationTitle(_ title: String) {
        navigationController?.navigationBar.topItem?.title = title
    }
    
    func configureActivityIndicatorView() {
        activityIndicatorView.startAnimating()
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    func updateConditionLabel(iconName: String, condition: String) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(iconName)@2x.png")
        conditionIcon.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        let description = NSAttributedString(
            string: "오늘의 날씨는 \(condition) 입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: condition
        )
        conditionLabel.attributedText = description
    }
    
    func updateTempLabel(temp: Double, tempMin: Double, tempMax: Double) {
        let tempColor = tempColor(temp)
        let temp = String(format: "%.1f°", temp)
        tempLabel.attributedText = NSAttributedString(
            string: "현재 온도는 \(temp) 입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: tempColor
            ],
            at: temp
        )
        
        let tempMinColor = self.tempColor(tempMin, defaultColor: .secondaryLabel)
        let tempMaxColor = self.tempColor(tempMax, defaultColor: .secondaryLabel)
        let tempMin = String(format: "%.1f°", tempMin)
        let tempMax = String(format: "%.1f°", tempMax)
        let minAttributedString = NSAttributedString(
            string: "최저\(tempMin)"
        ).addAttributes(
            [.foregroundColor: tempMinColor],
            at: tempMin
        )
        let maxAttributedString = NSAttributedString(
            string: "최고\(tempMax)"
        ).addAttributes(
            [.foregroundColor: tempMaxColor],
            at: tempMax
        )
        let attributedText = NSMutableAttributedString(attributedString: minAttributedString)
        attributedText.append(NSAttributedString(string: " "))
        attributedText.append(maxAttributedString)
        minMaxTempLabel.attributedText = attributedText
    }
    
    func updateFeelsLikeLabel(feelsLike: Double) {
        let color = tempColor(feelsLike)
        let feelsLike = String(format: "%.1f°", feelsLike)
        let text = NSAttributedString(
            string: "체감 온도는 \(feelsLike)입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [
                .font: UIFont.systemFont(ofSize: 16, weight: .bold),
                .foregroundColor: color
            ],
            at: feelsLike
        )
        feelsLikeLabel.attributedText = text
    }
    
    func updateSunTimeLabel(sunrise: Date, sunset: Date) {
        let sunrise = (sunrise).toString(.a_HH시mm분)
        let sunset = (sunset).toString(.a_HH시mm분)
        let text = NSAttributedString(
            string: "서울의 일출 시각은 \(sunrise), 일몰 시각은 \(sunset) 입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: sunrise, sunset
        )
        sunTimeLabel.attributedText = text
    }
    
    func updateHumidityWindLabel(humidity: Double, wind: Double) {
        let humidity = "\(humidity)%"
        let wind = String(format: "%.2fm/s", wind)
        let text = NSAttributedString(
            string: "습도는 \(humidity) 이고, 풍속은 \(wind)입니다",
            attributes: [.font: UIFont.systemFont(ofSize: 16)]
        ).addAttributes(
            [.font: UIFont.systemFont(ofSize: 16, weight: .bold)],
            at: humidity, wind
        )
        humidityWindLabel.attributedText = text
    }
    
    func updatePhotoImage(photo: PhotoEntity) {
        delegate?.updatePhotoImage(photo: photo)
        photoImageView.kf.setImage(
            with: photo.url,
            options: [.transition(.fade(0.3))]
        )
        photoImageView.snp.remakeConstraints { make in
            make.top.equalTo(todayPhotoLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview().inset(12)
            if photo.height < photo.width {
                make.height.equalTo(photoImageView.snp.width).multipliedBy(photo.width / photo.height)
            } else {
                make.height.equalTo(photoImageView.snp.width).multipliedBy(photo.height / photo.width)
            }
        }
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
                case let .isLoading(isLoading):
                    self?.bindIsLoading(isLoading)
                }
            }
        }
    }
    
    func bindWeather(_ weather: WeatherEntity?) {
        print(#function)
        
        guard let weather else { return }
        
        delegate?.bindWeather()
        
        configureNavigationTitle("\(weather.country), \(weather.name)")
        
        configureDateLabel(date: weather.date)
        
        dateLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalToSuperview().offset(20)
        }
        
        updateConditionLabel(
            iconName: weather.icon.first ?? "",
            condition: weather.description.first ?? ""
        )
        
        updateTempLabel(
            temp: weather.temp,
            tempMin: weather.tempMin,
            tempMax: weather.tempMax
        )
        
        updateFeelsLikeLabel(feelsLike: weather.feelsLike)
        
        updateSunTimeLabel(
            sunrise: weather.sunrise,
            sunset: weather.sunset
        )
        
        updateHumidityWindLabel(
            humidity: weather.humidity,
            wind: weather.windSpeed
        )
        
        weatherVStack.subviews.forEach { view in
            view.snp.updateConstraints { make in
                make.leading.equalToSuperview()
            }
        }
        
        viewModel.input(.bindWeather)
    }
    
    func bindPhoto(_ photo: PhotoEntity?) {
        guard let photo else { return }
        print(#function)
        
        updatePhotoImage(photo: photo)
    }
    
    func bindIsLoading(_ isLoading: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.contentView.alpha = isLoading ? 0 : 1
            self?.activityIndicatorView.alpha = isLoading ? 1 : 0
        } completion: { [weak self] _ in
            if isLoading {
                self?.activityIndicatorView.startAnimating()
            } else {
                self?.activityIndicatorView.stopAnimating()
            }
        }
    }
}

// MARK: Functions
private extension CityViewController {
    func refreshButtonTouchUpInside() {
        viewModel.input(.refreshButtonTouchUpInside)
    }
    
    func searchButtonTouchUpInside() {
        delegate?.searchButtonTouchUpInside()
    }
    
    func tempColor(_ temp: Double, defaultColor: UIColor = .label) -> UIColor {
        let color: UIColor = (temp > 30) ? .systemOrange : ((temp < 0) ? .systemBlue : defaultColor)
        return color
    }
}

@available(iOS 17.0, *)
#Preview {
    UINavigationController(rootViewController: CityViewController(viewModel: CityViewModel(useCase: CityUseCase(
        weatherRepository: TestWeatherRepository(),
        photoRepository: TestPhotoRepository()
    ))))
    
}
