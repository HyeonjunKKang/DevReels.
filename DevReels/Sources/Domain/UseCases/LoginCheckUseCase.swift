//
//  LoginCheckUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct LoginCheckUseCase: LoginCheckUseCaseProtocol {
    
    var tokenRepository: TokenRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    
    func loginCheck() -> Observable<Authorization> {
        return tokenRepository?.load() ?? .empty()
    }
    
    func currentUser() -> Observable<User> {
        return userRepository?.currentUser() ?? .empty()
    }
}
