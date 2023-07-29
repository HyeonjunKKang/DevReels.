//
//  UserRepository.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UserRepository: UserRepositoryProtocol {
    
    enum UserRepositoryError: Error {
        case userNotFound
    }
    
    var userDataSource: UserDataSourceProtocol?
    var keyChainManager: KeychainManagerProtocol?
    
    func fetch(uid: String) -> Observable<User> {
        return userDataSource?.read(uid: uid)
            .map { $0.toDomain() } ?? .empty()
    }
    
    func currentUser() -> Observable<User> {
        guard let data = keyChainManager?.load(key: .authorization),
              let authorization = try? JSONDecoder().decode(Authorization.self, from: data) else {
            return Observable.error(UserRepositoryError.userNotFound)
        }
        
        return fetch(uid: authorization.localId)
    }
    
    func exist() -> Observable<Bool> {
        guard let data = keyChainManager?.load(key: .authorization),
              let authorization = try? JSONDecoder().decode(Authorization.self, from: data) else {
            return Observable.error(UserRepositoryError.userNotFound)
        }
        
        return userDataSource?.exist(uid: authorization.localId) ?? .empty()
    }
    
    func set(profile: Profile, imageData: Data?) -> Observable<Void> {
        guard let data = keyChainManager?.load(key: .authorization),
              let authorization = try? JSONDecoder().decode(Authorization.self, from: data) else {
            return Observable.error(UserRepositoryError.userNotFound)
        }
        
        return Observable.just(imageData ?? Data())
            .flatMap { imageData in
                guard !imageData.isEmpty else { return Observable.just("") }
                return userDataSource?.uploadProfileImage(uid: authorization.localId, imageData: imageData)
                    .map { $0.absoluteString }
                    .catchAndReturn("") ?? Observable.just("")
            }
            .map {
                let user = User(uid: authorization.localId,
                     identifier: authorization.email,
                     profileImageURLString: $0,
                     profile: profile)
                print(user)
                return user
            }
            .flatMap {
                userDataSource?.set(request: UserRequestDTO(user: $0)) ?? .empty()
            }
    }
    
    func fetchFollower(uid: String) -> Observable<[User]> {
        return userDataSource?.fetchFollower(uid: uid)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func fetchFollowing(uid: String) -> Observable<[User]> {
        return userDataSource?.fetchFollowing(uid: uid)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func follow(targetUser: User, currentUser: User) -> Observable<Void> {
        return userDataSource?.follow(targetUserData: targetUser, myUserData: currentUser) ?? .empty()
    }
    
    func unfollow(targetUser: User, currentUser: User) -> Observable<Void> {
        return userDataSource?.unfollow(targetUserData: targetUser, myUserData: currentUser) ?? .empty()
    }
    
    func update(user: User) {
        userDataSource?.update(user: user)
    }
}
