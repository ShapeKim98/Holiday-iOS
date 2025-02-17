//
//  CityTableViewCell.swift
//  Holiday
//
//  Created by 김도형 on 2/16/25.
//

import UIKit

import Kingfisher
import SnapKit

class CityCollectionViewCell: UICollectionViewCell {
    private let nameLabel = UILabel()
    private let countryLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let conditionImageView = UIImageView()
    private let tempLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forRowAt(_ weather: WeatherEntity) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(weather.icon.first ?? "")@2x.png")
        conditionImageView.kf.setImage(with: url)
        
        nameLabel.text = weather.name
        countryLabel.text = weather.country
        
        let tempMin = String(format: "%.1f°C", weather.tempMin)
        let tempMax = String(format: "%.1f°C", weather.tempMax)
        minMaxTempLabel.text = "최저\(tempMin) 최고\(tempMax)"
        
        tempLabel.text = String(format: "%.1f°C", weather.temp)
    }
}

// MARK: Configure Views
private extension CityCollectionViewCell {
    func configureUI() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.addSubview(conditionImageView)
        
        configureNameLabel()
        
        configureCountryLabel()
        
        configureMinMaxTempLabel()
        
        configureTempLabel()
        
        configureConditionImageView()
    }
    
    func configureLayout() {
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(12)
        }
        
        minMaxTempLabel.snp.makeConstraints { make in
            make.leading.bottom.equalToSuperview().inset(12)
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.size.equalTo(60)
            make.top.trailing.equalToSuperview().inset(12)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(12)
        }
    }
    
    func configureNameLabel() {
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        contentView.addSubview(nameLabel)
    }
    
    func configureCountryLabel() {
        countryLabel.font = .systemFont(ofSize: 14, weight: .regular)
        countryLabel.textColor = .secondaryLabel
        contentView.addSubview(countryLabel)
    }
    
    func configureMinMaxTempLabel() {
        minMaxTempLabel.font = .systemFont(ofSize: 14, weight: .regular)
        minMaxTempLabel.textColor = .secondaryLabel
        contentView.addSubview(minMaxTempLabel)
    }
    
    func configureTempLabel() {
        tempLabel.font = .systemFont(ofSize: 24, weight: .bold)
        contentView.addSubview(tempLabel)
    }
    
    func configureConditionImageView() {
        conditionImageView.contentMode = .scaleAspectFill
        conditionImageView.clipsToBounds = true
    }
}
