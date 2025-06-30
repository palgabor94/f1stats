//
//  DriverInfoRow.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}
