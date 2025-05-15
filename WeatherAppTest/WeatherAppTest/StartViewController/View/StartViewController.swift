//
//  ViewController.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import UIKit

class StartViewController: UIViewController {
    
    private let viewModel = StartViewModel()
    private let startView = StartView()
    
    let weatherCellCollection = "WeatherCellCollection"
    let weatherSevenDaysCell = "WeatherSevenDaysCell"
    
    private var hour: [Hour] = []
    private var forecastDay: [ForecastDay] = []
    
//    MARK: LoadView
    override func loadView() {
        self.view = startView
    }

//    MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.locationRequest()
        setupBinding()
        
        startView.collectionView.dataSource = self
        
        startView.tableView.dataSource = self
        startView.tableView.delegate = self
    }

    private func setupBinding() {
        viewModel.onWeatherUpdate = { [weak self] location, current, forecast in
            guard let self = self else { return }
            startView.nameCity.text = location.name
            
            let roundedTemp = Int(round(current.temp_c))
            startView.temperature.text = "\(roundedTemp)°"
            
            let raundedMaxTemp = Int(round(forecast.forecastday.first?.day.maxtemp_c ?? 0))
            let raundedMinTemp = Int(round(forecast.forecastday.first?.day.mintemp_c ?? 0))
            
            startView.maxAndMinTemp.text = "Макс.:\(raundedMaxTemp)°, Мин.:\(raundedMinTemp)°"
            
            let currentTime = Date().timeIntervalSince1970

            self.hour = forecast.forecastday.first?.hour.filter {
                Double($0.time_epoch) >= currentTime
            } ?? []
            
            DispatchQueue.main.async {
                self.startView.collectionView.reloadData()
            }
        }
        
        viewModel.onWeatherFewDays = { [weak self] forecastDay in
            guard let self = self else { return }
            self.forecastDay = forecastDay
            
            DispatchQueue.main.async {
                self.startView.tableView.reloadData()
            }
        }
    }
}

extension StartViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastDay.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherSevenDaysCell, for: indexPath) as? WeatherSevenDaysCell
        
        let forecastDay = forecastDay[indexPath.row]
        cell?.configure(forecastDay)
        cell?.dateText.text = viewModel.formatterDate(forecastDay.date)
        
        viewModel.loadIcon(urlIcon: forecastDay.day.condition.icon) { image in
            DispatchQueue.main.async {
                cell?.iconWeather.image = image
            }
        }
        
        return cell ?? UITableViewCell()
    }
    
    
}

//MARK: - UICollectionViewDataSource
extension StartViewController: UICollectionViewDataSource, UITableViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hour.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weatherCellCollection, for: indexPath) as? WeatherCellCollection
        
        let hour = hour[indexPath.row]
        cell?.configure(hour)
        
        viewModel.loadIcon(urlIcon: hour.condition.icon) { image in
            DispatchQueue.main.async {
                cell?.iconWeather.image = image
            }
        }
        
        return cell ?? UICollectionViewCell()
        
    }
}

