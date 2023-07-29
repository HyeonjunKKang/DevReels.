//
//  Authorization.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/23.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct Authorization: Codable {
    let idToken: String
    let email: String
    let refreshToken: String
    let localId: String
}
