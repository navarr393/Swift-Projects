//
//  TabBarView.swift
//  WeatherAPI
//
//  Created by David Navarro on 7/5/24.
//

import SwiftUI

struct TabBarView: View {
    // make the tabbar systemcolor gray
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGray5
    }
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart")
                    Text("Favorites")
                }
        }
    }
}

#Preview {
    TabBarView()
}
