//
//  WeatherSevenDaysHeader.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 15.05.2025.
//

import UIKit
import SnapKit

final class WeatherSevenDaysHeader: UICollectionReusableView {
    
    static let identifier = "WeatherSevenDaysHeader"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Прогноз на несколько дней"
        label.font = UIFont.boldSystemFont(ofSize: 19)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
