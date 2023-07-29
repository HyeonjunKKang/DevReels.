//
//  AuthRepository.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseAuth

enum AuthError: Error {
    case signInError
}

struct AuthRepository: AuthRepositoryProtocol {
    // API 사용
    
    var authService: AuthServiceProtocol?
    private let disposeBag = DisposeBag()
    
    func signIn(with credential: OAuthCredential) -> Observable<Authorization> {
        let reqeust = OAuthAuthorizationRequestDTO(idToken: credential.idToken ?? "")
        
        return authService?.login(reqeust)
            .map { $0.toDomain() } ?? .empty()
    }
}
