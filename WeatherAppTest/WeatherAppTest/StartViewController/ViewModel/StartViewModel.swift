//
//  StartViewModel.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import CoreLocation
import UIKit

final class StartViewModel: NSObject {
    
    let locationManager = CLLocationManager()
    var onWeatherUpdate: ((Location, Current, Forecast) -> Void)?
    
    var onWeatherFewDays: (([ForecastDay]) -> Void)?
    var onShowAlert: ((UIAlertController) -> Void)?
    
    private var network = NetworkManager.shared
    
//    запрос геолокации
    func start() {
        locationManager.delegate = self
        let lat = 55.7558
        let lon = 37.6173
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()

        case .restricted, .denied:
            print("Геолокация запрещена, используем координаты Москвы")
            requestWeather(lat: lat, lon: lon)

        @unknown default:
            print("Неизвестный статус геолокации")
            requestWeather(lat: lat, lon: lon)
        }
    }
    
//    прогноз погоды
    private func requestWeather(lat: Double, lon: Double) {
        
        network.requestWeather(lat: lat, lon: lon) { [weak self] location, current, forecast, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Ошибка загрузки \(error.localizedDescription)")
                
                DispatchQueue.main.async {
                    self.showRetryAlert(lat: lat, lon: lon)
                }
            }
            
            guard let location = location,
                  let current = current,
                  let forecast = forecast else { return }
            
            DispatchQueue.main.async {
                self.onWeatherUpdate?(location, current, forecast)
            }
        }
        
        network.requestWeatherFewDays(lat: lat, lon: lon) { [weak self] forecastDay in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.onWeatherFewDays?(forecastDay)
            }
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    /// загрузка иконки погоды
    /// - Parameters:
    ///   - urlIcon: ссылка
    ///   - completion: completion
    func loadIcon(urlIcon: String, completion: @escaping (UIImage?) -> Void) {
        let url = "https:" + urlIcon
        
        guard let url = URL(string: url) else {
            print("Неверный URL")
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Ошибка конвертации")
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
    
    /// форматирование полученной даты
    /// - Parameter dateString: дата
    /// - Returns: возвращаем исправленную дату
    func formatterDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM"
        
        if let date = inputFormatter.date(from: dateString) {
            switch true {
            case Calendar.current.isDateInToday(date):
                return "Сегодня"
            case Calendar.current.isDateInTomorrow(date):
                return "Завтра"
            default:
                return outputFormatter.string(from: date)
            }
        } else {
            return dateString
        }
    }
    
    private func showRetryAlert(lat: Double, lon: Double) {
        let alert = UIAlertController(title: "Ошибка",
                                      message: "Не удалось загрузить данные. Повторить попытку?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Повторить", style: .default, handler: { [weak self] _ in
            self?.requestWeather(lat: lat, lon: lon)
        }))
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        onShowAlert?(alert)
    }
}

//MARK: CLLocationManagerDelegate
extension StartViewModel: CLLocationManagerDelegate {
//    получение координат
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else {
            return
        }
        
        print("Полученные координаты: - Широта \(coordinates.latitude), Долгота \(coordinates.longitude)")
        requestWeather(lat: coordinates.latitude, lon: coordinates.longitude)
    }
    
    
//   вывод ошибки
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения координат \(error.localizedDescription)")

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        start()
    }
}
