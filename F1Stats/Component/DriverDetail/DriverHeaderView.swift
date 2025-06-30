//
//  DriverHeaderView.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct DriverHeaderView: View {
    let driver: Driver
    let image: UIImage?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 200)
                    .cornerRadius(10)
            }
            Text(driver.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            Text(driver.nationality)
                .font(.title2)
                .foregroundColor(.secondary)
        }
    }
}
