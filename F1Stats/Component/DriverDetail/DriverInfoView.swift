//
//  DriverInfoView.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct DriverInfoView: View {
    let driver: Driver
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            InfoRow(title: "Date of Birth", value: driver.dateOfBirth)
            InfoRow(title: "Code", value: driver.code ?? "N/A")
            InfoRow(title: "Number", value: driver.permanentNumber ?? "N/A")
        }
    }
}
