//
//  String+Extension.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/24.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import CryptoKit

extension String {
    func toSha256() -> String {
        let data = Data(self.utf8)
        let hashedData = SHA256.hash(data: data)
        let hashString = hashedData.compactMap { String(format: "%02x", $0) }.joined()
            
        return hashString
    }
}
