//
//  User.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

struct User: Codable {
    let id: String
    let name: String
    let profileImageURLString: String?
    let githubURL: String?
    let blogURL: String?
    let introduce: String?
}
