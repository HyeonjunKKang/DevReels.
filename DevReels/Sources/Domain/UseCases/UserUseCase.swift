//
//  UserUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/06.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UserUseCase: UserUseCaseProtocol {
    
    var userRepository: UserRepositoryProtocol?
    private let disposeBag = DisposeBag()
    
    func currentUser() -> Observable<User> {
        return userRepository?.currentUser() ?? .empty()
    }
    
    func fetchUser(uid: String) -> Observable<User> {
        return userRepository?.fetch(uid: uid) ?? .empty()
    }
}
