//
//  AppleAuthorizationRequestDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/21.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation


// MARK: - 파일 삭제 해야함.
/*
 
 https://identitytoolkit.googleapis.com/v1/accounts:signInWithIdp?key=AIzaSyCTlsmYAbjkphuJWVDXiPaJOC1ngU7TTiY&requestUri=https://devreels.firebaseapp.com/__/auth/handler&postBody=id_token=eyJraWQiOiJXNldjT0tCIiwiYWxnIjoiUlMyNTYifQ.eyJpc3MiOiJodHRwczovL2FwcGxlaWQuYXBwbGUuY29tIiwiYXVkIjoiY29tLnRlYW0uRGV2UmVlbHMiLCJleHAiOjE2ODQ4MzIzNDMsImlhdCI6MTY4NDc0NTk0Mywic3ViIjoiMDAwNTczLmZhZDVlNWI3NmE1YzRiMGU4MDk0Y2I3YTIyMzQwMmM5LjEwNTYiLCJub25jZSI6ImE3NTU2M2IwN2E3OGYxOTllODVjZTk4NDlhYWE0MGFmNDZhZWI5MDgzOGM1MDBjZThjOGNhYzBjMWRiNTM5OTUiLCJjX2hhc2giOiIyT2NwN0JuMWJHdzN3ckJ0R20wMDBRIiwiZW1haWwiOiJraGpqOTg2NUBuYXZlci5jb20iLCJlbWFpbF92ZXJpZmllZCI6InRydWUiLCJhdXRoX3RpbWUiOjE2ODQ3NDU5NDMsIm5vbmNlX3N1cHBvcnRlZCI6dHJ1ZX0.S87ZQvDJLedIff0IpvKgnjoBW6wBe30uT530dEMxIaRERsh8KZ1sYXklUrS8vBCbxRKvJltadUk-BmpFU6i618mnKjgMCqjvddaZnCcdsmrB80G4GlN8vXD-QdOWKsO4mXjaeJhCxPIk9h-gzNfJyRC5bKMbk6EkqvKeBDoRA6PdRnYoUWKAQtLruxr2Q65DLJhaAAsV5EiqbnDSktPBrAyl9dbIgA98xtxtNgb0kNjfYPYdy3W1gpz6hFiiz-mExsPc2gsWcZ4raqJ3c8gg4TrFLvafommxGyPqfDxx01VyJ7aQwZPDF2IjlqtXkXubE4IddGSdgt63BjcVlHv1GQ
 %26providerId=apple.com
 %26nonce=zBrCgZS4bjt1uURiizqDuDTEZ6clpHsA&returnIdpCredential=true&returnSecureToken=true
 
 */

// struct AppleAuthorizationRequestDTO: Encodable {
//    struct PostBody: Encodable{
//        let idtoken: String
//        let providerId: String
//        let nonce: String
//    }
//
//
//
//    init(appleLogin: AuthProps){
//        // MARK: - 삭제필요
//        self.requestUri = "https://devreels.firebaseapp.com/__/auth/handler"
//        self.postBody = "id_token=\(appleLogin.idToken)&providerId=apple.com&nonce=\(appleLogin.nonce)"
//        self.returnSecureToken = true
//        self.returnIdpCredential = true
//    }
// }
