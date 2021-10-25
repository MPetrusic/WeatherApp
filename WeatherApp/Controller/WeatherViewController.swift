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
    @IBOutlet weak var conditionDescriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var weatherManager = WeatherManager()
    private var forecastManager = ForecastManager()
    private let locationManager = CLLocationManager()
    
    private var forecastArray = [ForecastModel]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerSetup()
        setupViews()
    }
    
    private func locationManagerSetup() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        // Desired accuracy is configured in order to get data faster
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
    
    private func setupViews() {
        collectionView.dataSource = self
        collectionView.register(ForecastCollectionViewCell.nib(), forCellWithReuseIdentifier: ForecastCollectionViewCell.identifier)
        weatherManager.delegate = self
        forecastManager.delegate = self
        searchTextField.delegate = self
        dateLabel.text = Date().dateToString()
    }
    
    private func animateNewData() {
        temperatureLabel.layer.fadeAnimation(duration: 0.7)
        conditionImageView.layer.fadeAnimation(duration: 0.7)
        cityNameLabel.layer.fadeAnimation(duration: 0.7)
    }
    
    private func showAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @IBAction func searchBtnTapped(_ sender: Any) {
        searchTextField.endEditing(true)
    }
    
    @IBAction func locationBtnTapped(_ sender: Any) {
        locationManager.requestLocation()
    }
}

//MARK: - TextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        locationManager.stopUpdatingLocation()
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            if city != "" {
                weatherManager.fetchWeather(cityName: city)
                forecastManager.fetchForecast(cityName: city)
            }
        }
        searchTextField.text = ""
    }
}

//MARK: - CollectionViewDataSource

extension WeatherViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return forecastArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ForecastCollectionViewCell.identifier, for: indexPath) as! ForecastCollectionViewCell
        let currentRow = indexPath.row
        cell.weatherImageView.image = UIImage(systemName: forecastArray[currentRow].conditionName)
        cell.temperatureLabel.text = forecastArray[currentRow].temperatureString
        cell.dateLabel.text = forecastArray[currentRow].dateFormatted
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
            self.conditionDescriptionLabel.text = weather.description
            self.pressureLabel.text = weather.pressureString + " hPa"
            self.humidityLabel.text = weather.humidityString + " %"
            self.animateNewData()
        }
    }
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            self.showAlert(title: "Error", message: "Unable to fetch data for this city at the moment")
        }
    }
}

//MARK: - ForecastManagerDelegate

extension WeatherViewController: ForecastManagerDelegate {
    func didUpdateForecast(_ forecastManager: ForecastManager, forecast: [ForecastModel]) {
        forecastArray = forecast
    }
    func didFailToLoadForecastData(error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            forecastManager.fetchForecast(latitude: lat, longitude: lon)
        }
        animateNewData()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .denied {
            showAlert(title: "Location needed", message: "In order to use this app you need to allow location permission.")
        } else {
            locationManager.requestLocation()
        }
    }
}

