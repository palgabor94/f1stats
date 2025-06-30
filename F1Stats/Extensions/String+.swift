//
//  String+.swift
//  F1Stats
//
//  Created by Pál Gábor on 28/08/2024.
//

extension String {
    var nationalityFlag: String {
        let base : UInt32 = 127397
        var s = ""
        for v in self.uppercased().unicodeScalars {
            s.unicodeScalars.append(UnicodeScalar(base + v.value)!)
        }
        return String(s)
    }
}
