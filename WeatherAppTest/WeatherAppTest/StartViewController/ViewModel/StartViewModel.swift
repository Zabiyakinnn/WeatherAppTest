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
    
    func locationRequest() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    /// Запрос в сеть для получения прогноза погоды сегодняшнего дня
    /// - Parameters:
    ///   - lat: широта
    ///   - lon: долгота
    private func requestWeather(lat: Double, lon: Double, completion: @escaping(Location?, Current?, Forecast?) -> Void) {
        let apiKey = "fa8b3df74d4042b9aa7135114252304"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)"
        
        guard let url = URL(string: urlString) else {
//            вывод ошибки
            print("Неверный URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Ошибка получения данных")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(WeatherResponse.self, from: data)
                completion(response.location, response.current, response.forecast)
            } catch {
                print("Ошибка парсинга: \(error.localizedDescription)")
                completion(nil, nil, nil)
            }
        }
        
        task.resume()
    }
    
    /// Запрос в сеть для получения прогноза на несколько дней
    /// - Parameters:
    ///   - lat: широта
    ///   - lon: долгота
    private func requestWeatherFewDays(lat: Double, lon: Double, completion: @escaping([ForecastDay]) -> Void) {
        let apiKey = "fa8b3df74d4042b9aa7135114252304"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=7"
        
        guard let url = URL(string: urlString) else {
//            вывод ошибки
            print("Неверный URL")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("Ошибка получения данных")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(WeatherResponse.self, from: data)
                completion(response.forecast.forecastday)
            } catch {
                print("Ошибка парсинга: \(error.localizedDescription)")
            }
        }
        
        task.resume()
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
        inputFormatter.locale = Locale(identifier: "en_US_POSIX") // надёжная локаль

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM"
        
        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        } else {
            return dateString
        }
    }
    
}

extension StartViewModel: CLLocationManagerDelegate {
//    получение координат
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else {
            return
        }
        
        print("Полученные координаты: - Широта \(coordinates.latitude), Долгота \(coordinates.longitude)")
        
        requestWeather(lat: coordinates.latitude, lon: coordinates.longitude) { [weak self] location, current, forecast in
            guard let self = self,
                  let location = location,
                  let current = current,
                  let forecast = forecast else { return }
            
            DispatchQueue.main.async {
                self.onWeatherUpdate?(location, current, forecast)
            }
        }
        
        requestWeatherFewDays(lat: coordinates.latitude, lon: coordinates.longitude) { [weak self] forecastDay in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.onWeatherFewDays?(forecastDay)
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    
//   обработка ошибок
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения координат \(error.localizedDescription)")
    }
}
