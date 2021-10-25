//
//  CurrentWeatherData.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import Foundation

struct CurrentWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let pressure: Int
    let humidity: Int
}

struct Weather: Codable {
    let main: String
    let id: Int
}
