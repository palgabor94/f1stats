//
//  DriverInfoButton.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct DriverInfoButton: View {
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            Image(systemName: "info.circle")
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
