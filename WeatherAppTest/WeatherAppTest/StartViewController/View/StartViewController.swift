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
        viewModel.start()
        setupBinding()
        
        startView.collectionView.dataSource = self
        
        startView.tableView.dataSource = self
        startView.tableView.delegate = self
    }

    private func setupBinding() {
        startView.activityIndicator.startAnimating()
        
        viewModel.onWeatherUpdate = { [weak self] location, current, forecast in
            guard let self = self else { return }
            startView.nameCity.text = location.name
            startView.labelHeadline.text = "Текущее местоположение"
            
            let roundedTemp = Int(round(current.temp_c))
            startView.temperature.text = "\(roundedTemp)°"
            
            let raundedMaxTemp = Int(round(forecast.forecastday.first?.day.maxtemp_c ?? 0))
            let raundedMinTemp = Int(round(forecast.forecastday.first?.day.mintemp_c ?? 0))
            
            startView.maxAndMinTemp.text = "Макс.:\(raundedMaxTemp)°, Мин.:\(raundedMinTemp)°"
            
            let currentTime = Date().timeIntervalSince1970
            
            //сегодняшняя погода
            let today = forecast.forecastday.first?.hour.filter {
                Double($0.time_epoch) >= currentTime
            } ?? []
            
            //завтрашняя погода
            let tomorrow = forecast.forecastday[1].hour
            
            self.hour = today + tomorrow
            
            DispatchQueue.main.async {
                self.startView.collectionView.reloadData()
                self.startView.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.onWeatherFewDays = { [weak self] forecastDay in
            guard let self = self else { return }
            self.forecastDay = forecastDay
            
            DispatchQueue.main.async {
                self.startView.tableView.reloadData()
                self.startView.tableView.layoutIfNeeded()
                
                let height = self.startView.tableView.contentSize.height + 35
                self.startView.tableViewHeightConstraint?.update(offset: height)
                self.startView.activityIndicator.stopAnimating()
            }
        }
        
        viewModel.onShowAlert = { [weak self] alert in
            self?.present(alert, animated: true)
        }
    }
}

//MARK: UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        headerView.backgroundColor = .white

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.textAlignment = .center
        label.text = "Погноз погоды на несколько дней"
        label.font = UIFont.systemFont(ofSize: 19)
        label.textColor = UIColor(named: "ColorTextBlackAndWhite")
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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

