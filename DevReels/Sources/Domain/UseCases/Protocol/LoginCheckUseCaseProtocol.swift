//
//  LoginCheckUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

protocol LoginCheckUseCaseProtocol {
    func loginCheck() -> Observable<Authorization>
    func currentUser() -> Observable<User>
}
