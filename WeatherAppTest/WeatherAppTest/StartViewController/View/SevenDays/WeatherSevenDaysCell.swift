//
//  WeatherSevenDaysCell.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 15.05.2025.
//

import UIKit
import SnapKit

final class WeatherSevenDaysCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //   дата
    lazy var dateText: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        return label
    }()
    
    //    максимальная температура
    lazy var maxTemp: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        return label
    }()
    
    //    минимальная температура
    lazy var minTemp: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .gray
        return label
    }()
    
    //        иконка погоды
    lazy var iconWeather: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    func configure(_ forecastDay: ForecastDay) {
        let raundedMaxTemp = Int(round(forecastDay.day.maxtemp_c))
        let raundedMinTemp = Int(round(forecastDay.day.mintemp_c))
        
        minTemp.text = "\(raundedMinTemp)°"
        maxTemp.text = "\(raundedMaxTemp)°"
    }
}

//MARK: setupLoyout
extension WeatherSevenDaysCell {
    private func setupLoyout() {
        addSubview(dateText)
        addSubview(maxTemp)
        addSubview(minTemp)
        addSubview(iconWeather)
        setupConstraint()
    }
    
    private func setupConstraint() {
        dateText.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(4)
        }
        iconWeather.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(minTemp.snp.right).offset(-50)
            make.height.width.equalTo(35)
        }
        minTemp.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(maxTemp.snp.left).offset(-150)
        }
        maxTemp.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(4)
        }
    }
}
