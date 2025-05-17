//
//  StartView.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import UIKit
import SnapKit

final class StartView: UIView {
    
    var tableViewHeightConstraint: Constraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.systemBackground
        setupLoyout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: Content
    //    collection weather day
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10 // расстояние между элементами
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 60, height: 142) // размер элемента
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(WeatherCellCollection.self, forCellWithReuseIdentifier: "WeatherCellCollection")
        collectionView.backgroundColor = UIColor.systemBackground
        collectionView.layer.cornerRadius = 12
        collectionView.layer.masksToBounds = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    //     tableCell
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .plain)
        tableView.backgroundColor = UIColor.systemBackground
        tableView.separatorColor = .darkGray
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.register(WeatherSevenDaysCell.self, forCellReuseIdentifier: "WeatherSevenDaysCell")
        return tableView
    }()
    
    //    заголовок
    lazy var labelHeadline: UILabel = {
         let label = UILabel()
        label.text = "Загрузка местоположения"
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.boldSystemFont(ofSize: 28)
        label.textAlignment = .center
        return label
    }()
    
//    название города
    lazy var nameCity: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    //    название города
    lazy var temperature: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 78)
        label.textAlignment = .center
        return label
    }()
    
//    мин/макс температура
    lazy var maxAndMinTemp: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        label.font = UIFont.systemFont(ofSize: 21)
        label.textAlignment = .center
        return label
    }()
    
//    индикатор загрузки
    lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        return indicator
    }()
    
}

//MARK: - SetupLoyout
extension StartView {
    private func setupLoyout() {
        addSubview(labelHeadline)
        addSubview(nameCity)
        addSubview(temperature)
        addSubview(maxAndMinTemp)
        addSubview(collectionView)
        addSubview(tableView)
        addSubview(activityIndicator)
        setupConstraint()
    }
    
    private func setupConstraint() {
        labelHeadline.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(85)
            make.centerX.equalToSuperview()
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(labelHeadline.snp.bottom).inset(-18)
        }
        nameCity.snp.makeConstraints { make in
            make.top.equalTo(labelHeadline.snp.bottom).inset(-7)
            make.centerX.equalToSuperview()
        }
        temperature.snp.makeConstraints { make in
            make.top.equalTo(nameCity.snp.bottom).inset(-7)
            make.centerX.equalToSuperview()
        }
        maxAndMinTemp.snp.makeConstraints { make in
            make.top.equalTo(temperature.snp.bottom).inset(-7)
            make.centerX.equalToSuperview()
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(maxAndMinTemp.snp.bottom).inset(-24)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(136)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).inset(-15)
            make.left.right.equalToSuperview().inset(15)
            self.tableViewHeightConstraint = make.height.equalTo(0).constraint
        }
    }
}
