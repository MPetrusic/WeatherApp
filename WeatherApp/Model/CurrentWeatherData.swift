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
}

struct Weather: Codable {
    let description: String
    let id: Int
}
