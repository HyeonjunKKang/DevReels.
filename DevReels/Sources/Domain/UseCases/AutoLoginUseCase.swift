//
//  AutoLoginUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

struct AutoLoginUseCase: AutoLoginUseCaseProtocol {
    var userRepository: UserRepositoryProtocol?
    
    func load() -> Observable<User> {
        return userRepository?.currentUser() ?? .empty()
    }
}
