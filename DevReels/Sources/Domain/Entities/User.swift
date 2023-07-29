//
//  User.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct User: Codable {
    let identifier: String
    let profileImageURLString: String
    let nickName: String
    let githubURL: String
    let blogURL: String
    let introduce: String
    var likedList: [String]
    let uid: String
}

extension User {
    init(uid: String, identifier: String) {
        self.uid = uid
        self.identifier = identifier
        self.profileImageURLString = ""
        self.githubURL = ""
        self.blogURL = ""
        self.nickName = ""
        self.introduce = ""
        self.likedList = []
    }
    
    init(uid: String, identifier: String, profileImageURLString: String, profile: Profile) {
        self.uid = uid
        self.identifier = identifier
        self.profileImageURLString = profileImageURLString
        self.githubURL = profile.githubURLString
        self.blogURL = profile.blogURLString
        self.nickName = profile.nickName
        self.introduce = profile.introduce
        self.likedList = []
    }
}
