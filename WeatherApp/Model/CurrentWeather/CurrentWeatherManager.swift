//
//  CurrentWeatherManager.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: CurrentWeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    private enum Request {
        static let baseUrl = "https://api.openweathermap.org/data/2.5/weather?appid=%@&units=metric"
        static let apiKey = "013065561ef5cb6685e98834eacdca52"
    }
    
    private let weatherURL = String(format: Request.baseUrl,Request.apiKey)
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let cityNameFormatted = cityName.preparedForRequest()
        let urlString = "\(weatherURL)&q=\(cityNameFormatted)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    private func parseJSON(_ weatherdata: Data) -> CurrentWeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrentWeatherData.self, from: weatherdata)
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let pressure = decodedData.main.pressure
            let humidity = decodedData.main.humidity
            let description = decodedData.weather[0].main
            
            let weather = CurrentWeatherModel(conditionId: id, cityName: name, temperature: temp, pressure: pressure, humidity: humidity, description: description)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
