//
//  ProfileUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/12.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol ProfileUseCaseProtocol {
    func follower(uid: String) -> Observable<[User]>
    func following(uid: String) -> Observable<[User]>
    func follow(target: User) -> Observable<Void>
    func unfollow(target: User) -> Observable<Void>
}
