//
//  DriverRow.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct DriverRow: View {
    let driver: Driver
    
    var body: some View {
        HStack {
            NavigationLink(destination: DriverDetailView(driverId: driver.id)) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(driver.familyName)
                        .font(.headline)
                    Text(driver.nationalityFlag)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("Born: \(formattedDate(driver.dateOfBirth))")
                        .font(.caption)
                    Text("Number: \(driver.permanentNumber ?? "N/A")")
                        .font(.caption)
                }
                .foregroundColor(.primary)
            }
            Spacer()
            DriverInfoButton(url: driver.url)
        }
        .padding(.vertical, 4)
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "MMM d, yyyy"
            return dateFormatter.string(from: date)
        }
        return dateString
    }
}
