//
//  Location.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/7/24.
//

import Foundation
import SwiftData


// class to add a new city
extension Location: Hashable {
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.cityName == rhs.cityName
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(cityName)
    }
}


@Model
class Location: ObservableObject, Identifiable {
    let cityName: String
    var details: String
    var temperature: String
    
    init(city: String) {
        self.cityName = city
        self.details = "Loading..."
        self.temperature = "Loading..."
        // Fetch weather data when a Location instance is created
        Task {
            await getWeather()
        }
    }
    
    func getWeather() async {
        guard !cityName.isEmpty else { return }
        
        let apiKey = "your api key here"
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)&units=imperial"
        
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let weatherArray = json["weather"] as? [[String: Any]],
                   let weather = weatherArray.first,
                   let description = weather["description"] as? String,
                   let main = json["main"] as? [String: Any],
                   let temp = main["temp"] as? Double {
                    
                    DispatchQueue.main.async {
                        self.details = description
                        self.temperature = "\(temp)°F"
                    }
                }
            } else {
                print("Failed to get a successful response: \(response)")
            }
        } catch {
            print("Error fetching weather data: \(error.localizedDescription)")
        }
    }
}
