//
//  ReelsRequestDTO.swift
//  DevReels
//
//  Created by HoJun on 2023/06/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct ReelsRequestDTO: Codable {
    let id: StringValue
    let uid: StringValue
    private let videoURL: StringValue
    private let thumbnailURL: StringValue
    private let title: StringValue
    private let videoDescription: StringValue
    private let githubUrl: StringValue
    private let blogUrl: StringValue
    private let hearts: IntegerValue
    private let date: IntegerValue
    
    
    private enum RootKey: String, CodingKey {
        case fields
    }
    
    private enum FieldKeys: String, CodingKey {
        case id, uid, videoURL, thumbnailURL, title, videoDescription, githubUrl, blogUrl, hearts, date
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: RootKey.self)
        var fieldContainer = container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        try fieldContainer.encode(self.id, forKey: .id)
        try fieldContainer.encode(self.uid, forKey: .uid)
        try fieldContainer.encode(self.videoURL, forKey: .videoURL)
        try fieldContainer.encode(self.thumbnailURL, forKey: .thumbnailURL)
        try fieldContainer.encode(self.title, forKey: .title)
        try fieldContainer.encode(self.videoDescription, forKey: .videoDescription)
        try fieldContainer.encode(self.githubUrl, forKey: .githubUrl)
        try fieldContainer.encode(self.blogUrl, forKey: .blogUrl)
        try fieldContainer.encode(self.hearts, forKey: .hearts)
        try fieldContainer.encode(self.date, forKey: .date)
    }
    
    init(reels: Reels) {
        self.id = StringValue(value: reels.id)
        self.uid = StringValue(value: reels.uid ?? "")
        self.videoURL = StringValue(value: reels.videoURL ?? "")
        self.thumbnailURL = StringValue(value: reels.thumbnailURL ?? "")
        self.title = StringValue(value: reels.title)
        self.videoDescription = StringValue(value: reels.videoDescription)
        self.githubUrl = StringValue(value: reels.githubUrl)
        self.blogUrl = StringValue(value: reels.blogUrl)
        self.hearts = IntegerValue(value: "\(reels.hearts)")
        self.date = IntegerValue(value: "\(reels.date)")
    }
}
