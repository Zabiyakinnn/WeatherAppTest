//
//  StartViewModel.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import CoreLocation

final class StartViewModel: NSObject {
    
    let locationManager = CLLocationManager()
    
    func locationRequest() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    /// Запрос в сеть для получения прогноза погоды
    /// - Parameters:
    ///   - lat: широта
    ///   - lon: долгота
    func requestWeather(lat: Double, lon: Double) {
        let apiKey = "fa8b3df74d4042b9aa7135114252304"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)"
        
        guard let url = URL(string: urlString) else {
//            вывод ошибки
            print("Неверный URL")
            return
        }
        print(url)
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
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Полученные данные: \(json)")
            } catch {
                print("Ошибка парсинга данных: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}

extension StartViewModel: CLLocationManagerDelegate {
//    получение координат
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinates = locations.last?.coordinate else {
            return
        }
        
        print("Полученные координаты: - Широта \(coordinates.latitude), Долгота \(coordinates.longitude)")
        
        requestWeather(lat: coordinates.latitude, lon: coordinates.longitude)
        locationManager.stopUpdatingLocation()
    }
    
    
//   обработка ошибок
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения координат \(error.localizedDescription)")
    }
}
