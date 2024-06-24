//
//  SplashScreenView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 5/20/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.teal
                .edgesIgnoringSafeArea(.all)
            Image(systemName: "applepencil.and.scribble")
                .font(.system(size: 50))

        }
    }
}

#Preview {
    SplashScreenView()
}
