//
//  ForecastModel.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import Foundation

struct ForecastModel {
    let conditionId: Int
    let temperature: Double
    let date: String
    
    var temperatureString: String {
        return String(format: "%.f", temperature)
    }
    
    var dateFormatted: String {
        // Convert string received to Date and back to String to reformat it
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "EE, d. MMM"
        
        if let date = dateFormatterGet.date(from: date) {
            return dateFormatterPrint.string(from: date)
        } else {
            return date
        }
    }

    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
