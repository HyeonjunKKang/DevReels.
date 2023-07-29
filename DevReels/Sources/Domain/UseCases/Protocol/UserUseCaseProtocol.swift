//
//  UserUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/12.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UserUseCaseProtocol {
    func currentUser() -> Observable<User>
    func fetchUser(uid: String) -> Observable<User>
}
