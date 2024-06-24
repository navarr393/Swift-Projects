//
//  DisplayActivityCardView.swift
//  HabitGuru 2.0
//
//  Created by David Navarro on 6/21/24.
//

import SwiftUI

struct DisplayActivityCardView: View {
    @EnvironmentObject var manager: HealthManager
    @Environment(\.colorScheme) var colorScheme

    private var backgroundColor: Color {
        return colorScheme == .light ? Color(UIColor.systemGray6) : .black
    }
    var body: some View {
        VStack(alignment: .leading) {
            Text("")
                .padding(4)
            Text("My Activities")
                .font(.system(size: 35, weight: .bold, design: .default))
                .padding()
            
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                ForEach(manager.activities.sorted(by: { $0.value.id < $1.value.id}), id: \.key) { item in
                    ActivityCardView(activity: item.value)
                }
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(backgroundColor)
    }
}

#Preview {
    DisplayActivityCardView()
}
