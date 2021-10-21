//
//  ForecastData.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import Foundation

struct ForecastData: Codable {
    let list: [ForecastList]
}

struct ForecastList: Codable {
    let main: [ForecastMain]
    let weather: [ForecastWeather]
    let dt_txt: String
}

struct ForecastMain: Codable {
    let temp: Double
}

struct ForecastWeather: Codable {
    let id: Int
}
