//
//  ForecastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "ForecastCollecitonViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "ForecastCollectionViewCell", bundle: nil)
    }
    
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
