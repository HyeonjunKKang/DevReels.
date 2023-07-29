//
//  FireStoreCollectionName.swift
//  DevReels
//
//  Created by HoJun on 2023/07/11.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

public enum FireStoreCollection: String {
    case users, reelsList, userReels
    
    var name: String {
        return self.rawValue
    }
}
