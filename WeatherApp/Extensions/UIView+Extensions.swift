//
//  UIView+Extensions.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import UIKit

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
