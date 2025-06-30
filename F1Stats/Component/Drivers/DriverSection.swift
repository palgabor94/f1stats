//
//  DriverSection.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

import SwiftUI

struct DriversSection: View {
    let drivers: [Driver]
    
    var body: some View {
        Section(header: Text("Drivers").font(.headline)) {
            ForEach(drivers, id: \.id) { driver in
                DriverRow(driver: driver)
            }
        }
    }
}
