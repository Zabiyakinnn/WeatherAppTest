//
//  NetworkManager.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 16.05.2025.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    /// Запрос в сеть для получения прогноза погоды сегодняшнего дня
    /// - Parameters:
    ///   - lat: широта
    ///   - lon: долгота
    func requestWeather(lat: Double, lon: Double, completion: @escaping(Location?, Current?, Forecast?, Error?) -> Void) {
        let apiKey = "fa8b3df74d4042b9aa7135114252304"
        let urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(lat),\(lon)&days=2"
        
        guard let url = URL(string: urlString) else {
//            вывод ошибки
            print("Неверный URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            if let error = error {
                print("Ошибка запроса: \(error.localizedDescription)")
                completion(nil, nil, nil, error)
                return
            }
            
            guard let data = data else {
                print("Ошибка получения данных")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(WeatherResponse.self, from: data)

                completion(response.location, response.current, response.forecast, nil)
            } catch {
                print("Ошибка парсинга: \(error.localizedDescription)")
                completion(nil, nil, nil, nil)
            }
        }
        
        task.resume()
    }
    
    /// Запрос в сеть для получения прогноза на несколько дней
    /// - Parameters:
    ///   - lat: широта
    ///   - lon: долгота
    func requestWeatherFewDays(lat: Double, lon: Double, completion: @escaping([ForecastDay]) -> Void) {
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
}
