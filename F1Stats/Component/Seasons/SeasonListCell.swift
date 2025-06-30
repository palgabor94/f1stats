//
//  SeasonListCell.swift
//  F1Stats
//
//  Created by Pál Gábor on 27/08/2024.
//

import SwiftUI

struct SeasonListCell: View {
    let season: Season

    var body: some View {
        HStack {
            NavigationLink(destination: DriversView(season: season.year)) {
                Text(season.year)
                    .foregroundColor(.primary)
            }
            Spacer()
            Button(action: {
                if let url = URL(string: "https://en.wikipedia.org/wiki/\(season.year)_Formula_One_World_Championship") {
                    UIApplication.shared.open(url)
                }
            }) {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.vertical, 8)
    }
}
