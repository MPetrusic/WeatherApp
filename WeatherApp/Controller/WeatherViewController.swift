//
//  ViewController.swift
//  WeatherApp
//
//  Created by Milos Petrusic on 21.10.21..
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        collectionView.register(ForecastCollectionViewCell.nib(), forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
        weatherManager.delegate = self
        dateLabel.text = Date().dayOfWeek()
    }
}

//MARK: - CollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as! ForecastCollectionViewCell
        cell.weatherImageView.image = UIImage(systemName: "sun.max.fill")
        cell.dateLabel.text = "Thu 21 Oct"
        cell.temperatureLabel.text = "25"
        return cell
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: CurrentWeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            
            self.cityNameLabel.text = weather.cityName
            
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

