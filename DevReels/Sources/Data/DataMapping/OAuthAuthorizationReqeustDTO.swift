//
//  OAuthAuthorizationReqeustDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct OAuthAuthorizationRequestDTO: Encodable {
    private let requestUri: String
    private let postBody: String
    private let returnSecureToken: Bool
    private let returnIdpCredential: Bool
    
    init(idToken: String) {
        self.requestUri = "https://devreels.firebaseapp.com/__/auth/handler"
        self.postBody = "id_token=\(idToken)&providerId=apple.com"
        self.returnSecureToken = true
        self.returnIdpCredential = true
    }
}
