//
//  UserResponseDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct UserResponseDTO: Decodable {
    let identifier: String
    let profileImageURLString: String
    let nickName: String
    let githubURL: String
    let blogURL: String
    let introduce: String
    let likedList: [String]
    let uid: String
    
    init(user: User) {
        self.identifier = user.identifier
        self.profileImageURLString = user.profileImageURLString
        self.nickName = user.nickName
        self.githubURL = user.githubURL
        self.blogURL = user.blogURL
        self.introduce = user.introduce
        self.likedList = user.likedList
        self.uid = user.uid
    }
    
    func toDomain() -> User {
        return User(identifier: identifier,
                    profileImageURLString: profileImageURLString,
                    nickName: nickName,
                    githubURL: githubURL,
                    blogURL: blogURL,
                    introduce: introduce,
                    likedList: likedList,
                    uid: uid)
    }
}
