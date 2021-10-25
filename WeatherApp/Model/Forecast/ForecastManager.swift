//
//  ForecastManager.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import Foundation
import CoreLocation

protocol ForecastManagerDelegate {
    func didUpdateForecast(_ forecastManager: ForecastManager, forecast: [ForecastModel])
    func didFailToLoadForecastData(error: Error)
}

struct ForecastManager {
    
    private enum Request {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/forecast?appid=%@&units=metric"
        static let apiKey = "013065561ef5cb6685e98834eacdca52"
    }
    
    private let timeToCheckWeather = "12:00:00"
    
    private let forecastURL = String(format: Request.baseUrl, Request.apiKey)
    
    var delegate: ForecastManagerDelegate?
    
    func fetchForecast(cityName: String) {
        let cityNameFormatted = cityName.preparedForRequest()
        let urlString = "\(forecastURL)&q=\(cityNameFormatted)"
        performRequest(with: urlString)
    }
    
    func fetchForecast(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(forecastURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, _, error in
            if error != nil {
                delegate?.didFailToLoadForecastData(error: error!)
            }
            if let safeData = data {
                if let forecast = self.parseJSON(safeData) {
                    self.delegate?.didUpdateForecast(self, forecast: forecast)
                }
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherdata: Data) -> [ForecastModel]? {
        let decoder = JSONDecoder()
        do {
            var forecastArray: [ForecastModel] = []
            var forecastList: [ForecastList] = []
            let forecastData = try decoder.decode(ForecastData.self, from: weatherdata)
            var i = 0
            for forecast in forecastData.list {
                if let date = forecast.dt_txt?.components(separatedBy: " "),
                    date.count == 2,
                    date[1] == self.timeToCheckWeather {
                    forecastList.append(forecast)
                    let id = forecastList[i].weather[0].id
                    let temp = forecastList[i].main.temp
                    let date = forecastList[i].dt_txt
                    forecastArray.append(ForecastModel(conditionId: id, temperature: temp, date: date ?? ""))
                    i += 1
                }
            }
            
            return forecastArray
        } catch {
            delegate?.didFailToLoadForecastData(error: error)
            return nil
        }
    }
    
}
