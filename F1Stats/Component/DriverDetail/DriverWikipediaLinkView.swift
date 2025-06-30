//
//  DriverWikipediaLinkView.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct WikipediaLinkView: View {
    let driverName: String
    
    var body: some View {
        Button(action: openWikipedia) {
            HStack {
                Image(systemName: "link")
                Text("More on Wikipedia")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
    
    private func openWikipedia() {
        if let url = URL(string: "https://en.wikipedia.org/wiki/\(driverName.replacingOccurrences(of: " ", with: "_"))") {
            UIApplication.shared.open(url)
        }
    }
}
