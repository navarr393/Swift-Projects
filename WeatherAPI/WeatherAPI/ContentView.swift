//
//  ContentView.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/3/24.
//

import SwiftUI
import SwiftData
import CoreLocation

struct ContentView: View {
    @StateObject private var locationManager = LocationManager()
    
    @State private var location = ""
    @State private var description = ""
    @State private var temperature = ""
    @State private var isLoading = false
    @State private var sensory = false
    @State private var showingFavoritesView = false
    
    // Define grid layout
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .padding(10)
                        TextField("Search City", text: $location)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("My Current Location")
                            .font(.headline)
                            .foregroundStyle(.primary)
                        Text("City: \(locationManager.cityName)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        LazyVGrid(columns: columns, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Weather:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    // TODO: add a switch or enum to put an systemImage like in FavoritesView
                                    if locationManager.weatherDetails.contains("cloud") {
                                        Image(systemName: "cloud")
                                    } else if locationManager.weatherDetails.contains("clear") {
                                        Image(systemName: "sun.max")
                                    } else if locationManager.weatherDetails.contains("rain") {
                                        Image(systemName: "cloud.rain")
                                    } else if locationManager.weatherDetails.contains("snow") {
                                        Image(systemName: "snowflake")
                                    } else if locationManager.weatherDetails.contains("drizzle") {
                                        Image(systemName: "cloud.drizzle")
                                    } else if locationManager.weatherDetails.contains("thunderstorm") {
                                        Image(systemName: "cloud.bolt.rain")
                                    } else if locationManager.weatherDetails.contains("mist") {
                                        Image(systemName: "cloud.fog")
                                    } else if locationManager.weatherDetails.contains("haze") {
                                        Image(systemName: "sun.haze")
                                    } else if locationManager.weatherDetails.contains("fog") {
                                        Image(systemName: "cloud.fog")
                                    } else if locationManager.weatherDetails.contains("dust") {
                                        Image(systemName: "sun.dust")
                                    } else if locationManager.weatherDetails.contains("smoke") {
                                        Image(systemName: "smoke")
                                    }
                                    Text(locationManager.weatherDetails)
                                        
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("Temperature:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text(locationManager.temperature)
                            }
                        }
                    }
                    .onAppear {
                        locationManager.requestAuthorization()
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    if isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .padding()
                    }
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Weather Information")
                            .font(.headline)
                        
                        Text("Here is the current weather for: \(location)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        LazyVGrid(columns: columns, spacing: 20) {
                            VStack(alignment: .leading) {
                                Text("Description:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                HStack {
                                    if description.contains("cloud") {
                                        Image(systemName: "cloud")
                                    } else if description.contains("clear") {
                                        Image(systemName: "sun.max")
                                    } else if description.contains("rain") {
                                        Image(systemName: "cloud.rain")
                                    } else if description.contains("snow") {
                                        Image(systemName: "snowflake")
                                    } else if description.contains("drizzle") {
                                        Image(systemName: "cloud.drizzle")
                                    } else if description.contains("thunderstorm") {
                                        Image(systemName: "cloud.bolt.rain")
                                    } else if description.contains("mist") {
                                        Image(systemName: "cloud.fog")
                                    } else if description.contains("haze") {
                                        Image(systemName: "sun.haze")
                                    } else if description.contains("fog") {
                                        Image(systemName: "cloud.fog")
                                    } else if description.contains("dust") {
                                        Image(systemName: "sun.dust")
                                    } else if description.contains("smoke") {
                                        Image(systemName: "smoke")
                                    }
                                    Text("\(description)")
                                }
                            }
                            VStack(alignment: .leading) {
                                Text("Temperature:")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                Text("\(temperature)")
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    // TODO: find a way to just use one spacer
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()

                    Button(action: {
                        Task {
                            isLoading = true
                            sensory.toggle()
                            await getWeather()
                            isLoading = false
                        }
                    }) {
                        Text("Get Weather")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .sensoryFeedback(.increase, trigger: sensory)
                }
            }
            .navigationTitle("Weather")
            .toolbar {
                Button(action: {
                    showingFavoritesView = true
                }) {
                    Label("Add City", systemImage: "plus")
                }
            }
            .sheet(isPresented: $showingFavoritesView) {
                AddView()
            }
        }
    }
    
    func getWeather() async {
        // Ensure the location is not empty before proceeding
        guard !location.isEmpty else { return }
        
        // API key for OpenWeatherMap
        let apiKey = "your api key here"
        
        // Construct the URL string with the location and API key
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(apiKey)&units=imperial"
        
        // Create a URL object from the urlString
        guard let url = URL(string: urlString) else { return }
        
        do {
            // Perform the network request and wait for the response
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Parse the JSON response
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let weatherArray = json["weather"] as? [[String: Any]],
               let weather = weatherArray.first,
               let description = weather["description"] as? String,
               let main = json["main"] as? [String: Any],
               let temp = main["temp"] as? Double {
                
                // Update the UI on the main thread
                DispatchQueue.main.async {
                    self.description = description
                    self.temperature = "\(temp)°F"
                }
            }
        } catch {
            // Handle any errors that occurred during the network request or JSON parsing
            print("Error fetching weather data: \(error.localizedDescription)")
        }
    }

}

#Preview {
    ContentView()
}
