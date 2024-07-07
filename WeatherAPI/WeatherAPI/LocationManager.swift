//
//  LocationManager.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/6/24.
//

import Foundation
import CoreLocation

// this class handles user persmission and request to thrie location.
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var cityName: String = ""
    @Published var weatherDetails: String = ""
    @Published var temperature: String = ""
    
    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        self.location = location
        fetchCityName(from: location)
        fetchWeather(from: location)
    }
    
    func fetchCityName(from location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                self.cityName = placemark.locality ?? "Unknown location"
            }
        }
    }
    
    func fetchWeather(from location: CLLocation) {
        let apiKey = "your api key here"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let weatherArray = json["weather"] as? [[String: Any]],
                   let weather = weatherArray.first,
                   let description = weather["description"] as? String,
                   let main = json["main"] as? [String: Any],
                   let temp = main["temp"] as? Double {
                    
                    DispatchQueue.main.async {
                        self.weatherDetails = description
                        self.temperature = "\(temp)°F"
                    }
                }
            }
        }
        task.resume()
    }
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
}

