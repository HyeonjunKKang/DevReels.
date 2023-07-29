//
//  UserDataSourceProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDataSourceProtocol {
    func set(request: UserRequestDTO) -> Observable<Void>
    func exist(uid: String) -> Observable<Bool>
    func read(uid: String) -> Observable<UserResponseDTO>
    func uploadProfileImage(uid: String, imageData: Data) -> Observable<URL>
    func fetchFollower(uid: String) -> Observable<[UserResponseDTO]>
    func fetchFollowing(uid: String) -> Observable<[UserResponseDTO]>
    func follow(targetUserData: User, myUserData: User) -> Observable<Void>
    func unfollow(targetUserData: User, myUserData: User) -> Observable<Void>
    func update(user: User)
}
