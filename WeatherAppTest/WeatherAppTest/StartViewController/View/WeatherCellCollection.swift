//
//  WeatherCellCollection.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import UIKit
import SnapKit

final class WeatherCellCollection: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    время
    lazy var hourWeather: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = .white
        return label
    }()
    
//    температура
    lazy var temperature: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .white
        return label
    }()
    
    //        иконка погоды
    lazy var iconWeather: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    func configure(_ hour: Hour) {
        temperature.text = "\(Int(round(hour.temp_c)))°"
        
        let dateTime = hour.time
        let timePart = dateTime.components(separatedBy: " ")[1]
        let hourOnly = timePart.components(separatedBy: ":")[0]
        hourWeather.text = hourOnly
    }
}

//MARK: setupLoyout
extension WeatherCellCollection {
    private func setupLoyout() {
        addSubview(hourWeather)
        addSubview(temperature)
        addSubview(iconWeather)
        setupConstraint()
    }
    
    private func setupConstraint() {
        hourWeather.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.centerX.equalToSuperview()
        }
        temperature.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(18)
            make.centerX.equalToSuperview()
        }
        iconWeather.snp.makeConstraints { make in
            make.top.equalTo(hourWeather.snp.bottom).inset(-14)
            make.bottom.equalTo(temperature.snp.top).inset(-14)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(42)
        }
    }
}

