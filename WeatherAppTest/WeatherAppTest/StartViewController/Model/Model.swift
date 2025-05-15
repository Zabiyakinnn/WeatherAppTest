//
//  Model.swift
//  WeatherAppTest
//
//  Created by Дмитрий Забиякин on 13.05.2025.
//

import Foundation

struct WeatherResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
}

struct Current: Codable {
    let temp_c: Double
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let date: String
    let day: Day
    let hour: [Hour]
}

struct Day: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: Condition
}

struct Hour: Codable {
    let temp_c: Double
    let time: String
    let time_epoch: Int
    let condition: Condition
}

struct Condition: Codable {
    let icon: String
}
