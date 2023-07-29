//
//  AuthorizationResponseDTO.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct AuthorizationResponseDTO: Decodable {
    private let idToken: String
    private let email: String
    private let refreshToken: String
    private let localId: String
    
    func toDomain() -> Authorization {
        return Authorization(
            idToken: idToken,
            email: email,
            refreshToken: refreshToken,
            localId: localId)
    }
}
