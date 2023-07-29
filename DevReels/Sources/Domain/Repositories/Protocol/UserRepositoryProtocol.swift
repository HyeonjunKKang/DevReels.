//
//  UserRepositoryProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func set(profile: Profile, imageData: Data?) -> Observable<Void>
    func exist() -> Observable<Bool>
    func fetch(uid: String) -> Observable<User>
    func currentUser() -> Observable<User>
    func fetchFollower(uid: String) -> Observable<[User]>
    func fetchFollowing(uid: String) -> Observable<[User]>
    func follow(targetUser: User, currentUser: User) -> Observable<Void>
    func unfollow(targetUser: User, currentUser: User) -> Observable<Void>
    func update(user: User)
}
