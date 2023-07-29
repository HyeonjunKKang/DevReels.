//
//  Int+Formatter.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/06.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

extension Int {
    
    /// ex) 202212011700 ==> 2022년 12월 1일 17시 00분
    func toDateString() -> String {
        let inputformatter = DateFormatter()
        inputformatter.dateFormat = "yyyyMMddHHmmss"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy년MM월dd일 HH시mm분"
        
        if let date = inputformatter.date(from: String(self)) {
            let formattedDate = outputFormatter.string(from: date)
            return formattedDate
        } else {
            return "unKnown"
        }
    }
}
