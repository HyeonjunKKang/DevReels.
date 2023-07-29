//
//  Comment.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/29.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct Comment: Codable {
    let commentID: String
    let reelsID: String
    let writerUID: String
    let writerNickName: String
    let writerProfileImageURL: String
    let content: String
    let date: Int
    let likes: Int
}

extension Comment {
    // 댓글 생성 시
    init (reelsID: String, writerUID: String, writerProfileImageURL: String, content: String, writerNickName: String) {
        self.commentID = UUID().uuidString
        self.reelsID = reelsID
        self.writerUID = writerUID
        self.writerProfileImageURL = writerProfileImageURL
        self.content = content
        self.date = Date().toInt(dateFormat: Format.chatDateFormat)
        self.likes = 0
        self.writerNickName = writerNickName
    }
}
