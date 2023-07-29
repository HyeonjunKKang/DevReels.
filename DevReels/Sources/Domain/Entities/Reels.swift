//
//  Video.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct Reels: Codable {
    let id: String
    let title: String
    let videoDescription: String
    let githubUrl: String
    let blogUrl: String
    let hearts: Int
    let date: Int
    let uid: String?
    let videoURL: String?
    let thumbnailURL: String?
    
    // 생성 시
    init(id: String, title: String, videoDescription: String, githubUrl: String, blogUrl: String, uid: String? = nil, videoURL: String? = nil, thumbnailURL: String? = nil) {
        self.id = id
        self.title = title
        self.videoDescription = videoDescription
        self.githubUrl = githubUrl
        self.blogUrl = blogUrl
        self.hearts = 0
        self.date = Date().toInt(dateFormat: Format.chatDateFormat)
        self.uid = uid
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
    }
    
    // 로드 시
    init(id: String, title: String, videoDescription: String, githubUrl: String, blogUrl: String, hearts: Int, date: Int, uid: String?, videoURL: String?, thumbnailURL: String?) {
        self.id = id
        self.title = title
        self.videoDescription = videoDescription
        self.githubUrl = githubUrl
        self.blogUrl = blogUrl
        self.hearts = hearts
        self.date = date
        self.uid = uid
        self.videoURL = videoURL
        self.thumbnailURL = thumbnailURL
    }
    
    struct Constants {
        static let mockReels = Reels(id: "", title: "", videoDescription: "", githubUrl: "", blogUrl: "")
    }
}
