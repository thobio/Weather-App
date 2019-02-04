//
//  ViewController.swift
//  Weather App
//
//  Created by Thobio on 04/02/19.
//  Copyright © 2019 Zerone Consulting. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import GooglePlacePicker


class ViewController: UIViewController,CLLocationManagerDelegate,GMSPlacePickerViewControllerDelegate {
 

    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "5e341c07cb223a6c621e8ba3485e2564"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var weatherIcon: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO:Set up the loaction manager here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }

    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, parameters: [String: String]){
        Alamofire.request(url, method: .get, parameters:parameters, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if  response.result.isSuccess {
                let weatherJSON:JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            }else{
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
    
    
    //Write the updateWeatherData method here:
    
    func updateWeatherData(json: JSON){
        guard let tempResult = json["main"]["temp"].double else {
            self.cityLabel.text = "Weather Unavailable"
            return
        }
        weatherDataModel.temperature = Int(tempResult - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        self.updateUIWithWeatherData()
    }
    
    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        self.cityLabel.text = weatherDataModel.city
        self.temperatureLabel.text = "\(weatherDataModel.temperature)˚"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName!)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            let params:[String : String] = [
                                            "lat":latitude,
                                            "lon":longitude,
                                            "appid" : APP_ID
                                           ]
            
            getWeatherData(url:WEATHER_URL,parameters:params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Loaction Unvailable"
    }
    
    
    
    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    
    
    
    //Write the PrepareForSegue Method here
    
    
    @IBAction func loactionButton(_ sender: Any) {
        
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        placePicker.delegate = self
        present(placePicker, animated: true, completion: nil)
        
    }
    
    
    //MARK: - GMSPlacePicker ViewController Delegate Methods
    /***************************************************************/
    //Write the didPick method here:
    
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        
        let params:[String : String] = [
            "lat":String(place.coordinate.latitude),
            "lon":String(place.coordinate.longitude),
            "appid" : APP_ID
        ]
        
        getWeatherData(url:WEATHER_URL,parameters:params)
        
    }
    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
    }
    
}

