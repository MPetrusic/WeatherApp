//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import Foundation

extension Date {
    func dateToString() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d. MMM"
        return dateFormatter.string(from: self).capitalized
    }
}
