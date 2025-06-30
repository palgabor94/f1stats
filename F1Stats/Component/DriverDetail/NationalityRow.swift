//
//  NationalityRow.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct NationalityRow: View {
    let nationality: String
    let count: Int
    
    var body: some View {
        HStack {
            Text(nationality)
            Spacer()
            Text("\(count)")
                .foregroundColor(.secondary)
        }
    }
}
