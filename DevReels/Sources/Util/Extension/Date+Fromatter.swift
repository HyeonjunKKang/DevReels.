//
//  Date+Fromatter.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

extension Date {
    
    func toString(dateFormat: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return formatter.string(from: self)
    }
    
    func toInt(dateFormat: String) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        return Int(formatter.string(from: self)) ?? 0
    }
}
