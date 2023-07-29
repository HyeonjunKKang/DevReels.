//
//  Profile.swift
//  DevReels
//
//  Created by HoJun on 2023/07/07.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

struct Profile {
    let nickName: String
    let introduce: String
    let profileImage: UIImage?
    let githubURLString: String
    let blogURLString: String
    
    
    init(nickName: String, introduce: String, profileImage: UIImage?, githubURLString: String, blogURLString: String) {
        self.nickName = nickName
        self.introduce = introduce
        self.profileImage = profileImage
        self.githubURLString = githubURLString
        self.blogURLString = blogURLString
    }
}
