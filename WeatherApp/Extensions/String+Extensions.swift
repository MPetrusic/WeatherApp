//
//  String+Extensions.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 24.10.21..
//

import Foundation

extension String {
    func preparedForRequest() -> String {
        return replacingOccurrences(of: " ", with: "%20")
    }
}
