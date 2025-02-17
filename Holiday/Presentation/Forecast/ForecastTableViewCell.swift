//
//  ForecastTableViewCell.swift
//  Holiday
//
//  Created by 김도형 on 2/18/25.
//

import UIKit

import Kingfisher
import SnapKit

final class ForecastTableViewCell: UITableViewCell {
    private let dateLabel = UILabel()
    private let minMaxTempLabel = UILabel()
    private let conditionImageView = UIImageView()
    private let tempLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func forRowAt(_ forecast: ForecastEntity) {
        let url = URL(string: "https://openweathermap.org/img/wn/\(forecast.icon.first ?? "")@2x.png")
        conditionImageView.kf.setImage(
            with: url,
            options: [.transition(.fade(0.3))]
        )
        
        dateLabel.text = forecast.date.toString(.M_d_H_m)
        
        let tempMinColor = self.tempColor(forecast.tempMin, defaultColor: .secondaryLabel)
        let tempMaxColor = self.tempColor(forecast.tempMax, defaultColor: .secondaryLabel)
        let tempMin = String(format: "%.1f°", forecast.tempMin)
        let tempMax = String(format: "%.1f°", forecast.tempMax)
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
        
        tempLabel.text = String(format: "%.1f°C", forecast.temp)
        tempLabel.textColor = tempColor(forecast.temp)
    }
    
    private func tempColor(_ temp: Double, defaultColor: UIColor = .label) -> UIColor {
        let color: UIColor = (temp > 30) ? .systemOrange : ((temp < 0) ? .systemBlue : defaultColor)
        return color
    }
}

// MARK: Configure Views
private extension ForecastTableViewCell {
    func configureUI() {
        backgroundColor = .clear
        
        contentView.addSubview(conditionImageView)
        
        configureDateLabel()
        
        configureMinMaxTempLabel()
        
        configureTempLabel()
        
        configureConditionImageView()
    }
    
    func configureLayout() {
        dateLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        minMaxTempLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
        }
        
        conditionImageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalTo(dateLabel.snp.trailing).offset(8)
            make.verticalEdges.equalToSuperview().inset(8)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.leading.equalTo(conditionImageView.snp.trailing).offset(8)
            make.centerY.equalToSuperview()
        }
    }
    
    func configureDateLabel() {
        dateLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(dateLabel)
    }
    
    func configureMinMaxTempLabel() {
        minMaxTempLabel.font = .systemFont(ofSize: 14, weight: .regular)
        minMaxTempLabel.textColor = .secondaryLabel
        contentView.addSubview(minMaxTempLabel)
    }
    
    func configureTempLabel() {
        tempLabel.font = .systemFont(ofSize: 14, weight: .bold)
        contentView.addSubview(tempLabel)
    }
    
    func configureConditionImageView() {
        conditionImageView.contentMode = .scaleAspectFill
        conditionImageView.clipsToBounds = true
    }
}
