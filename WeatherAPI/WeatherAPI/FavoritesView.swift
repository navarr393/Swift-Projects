//
//  FavoritesView.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/5/24.
//

import SwiftUI
import SwiftData

// TODO: implement this later 
enum WeatherCondition: String {
    case clear = "clear"
    case clouds = "clouds"
    case rain = "rain"
    case snow = "snow"
    case drizzle = "drizzle"
    case thunderstorm = "thunderstorm"
    case mist = "mist"
    case haze = "haze"
    case fog = "fog"
    case dust = "dust"
    case smoke = "smoke"
    
    var systemImageName: String {
        switch self {
        case .clear:
            return "sun.max"
        case .clouds:
            return "cloud"
        case .rain:
            return "cloud.rain"
        case .snow:
            return "snow"
        case .drizzle:
            return "cloud.drizzle"
        case .thunderstorm:
            return "cloud.bolt.rain"
        case .mist:
            return "cloud.fog"
        case .haze:
            return "sun.haze"
        case .fog:
            return "cloud.fog"
        case .dust:
            return "sun.dust"
        case .smoke:
            return "smoke"
        }
    }
}

struct FavoritesView: View {
    @Environment(\.modelContext) var modelcontext
    @Query private var cities: [Location]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cities) { city in
                    HStack {
                        // TODO: update the following code to an enum or switch
                        if city.details.contains("clouds") {
                            Image(systemName: "cloud")
                        } else if city.details.contains("clear") {
                            Image(systemName: "sun.max")
                        } else if city.details.contains("rain") {
                            Image(systemName: "cloud.rain")
                        } else if city.details.contains("snow") {
                            Image(systemName: "snowflake")
                        } else if city.details.contains("drizzle") {
                            Image(systemName: "cloud.drizzle")
                        } else if city.details.contains("thunderstorm") {
                            Image(systemName: "cloud.bolt.rain")
                        } else if city.details.contains("mist") {
                            Image(systemName: "cloud.fog")
                        } else if city.details.contains("haze") {
                            Image(systemName: "sun.haze")
                        } else if city.details.contains("fog") {
                            Image(systemName: "cloud.fog")
                        } else if city.details.contains("dust") {
                            Image(systemName: "sun.dust")
                        } else if city.details.contains("smoke") {
                            Image(systemName: "smoke")
                        }
                        VStack(alignment: .leading) {
                            Text(city.cityName)
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text("Today: \(city.details)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text("Temperature: \(city.temperature)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onAppear { // when the Vstack appears the function will be called and fetch the current weather data for that specific city. Since this function is inside the loop it will be called for every city.
                        Task {
                            await city.getWeather()
                        }
                    }
                }
                .onDelete(perform: removeLocations)
            }
            .toolbar {
                EditButton()
            }
            .navigationTitle("Favorites")
        }
    }
    
    func removeLocations(at offsets: IndexSet) {
        for offset in offsets {
            let location = cities[offset]
            modelcontext.delete(location)
        }
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: Location.self)
}
