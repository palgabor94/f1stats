//
//  NationalitySummarySection.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct NationalitySummarySection: View {
    let nationalityCount: [String: Int]
    
    var body: some View {
        Section(header: Text("Nationality Summary").font(.headline)) {
            ForEach(nationalityCount.sorted(by: { $0.value > $1.value }), id: \.key) { nationality, count in
                NationalityRow(nationality: nationality, count: count)
            }
        }
    }
}
