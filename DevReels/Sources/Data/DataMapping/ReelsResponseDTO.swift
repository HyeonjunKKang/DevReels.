//
//  PostDTO.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/17.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct ReelsResponseDTO: Codable {
    private let id: StringValue
    private let uid: StringValue
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKey.self)
        let fieldContainer = try container.nestedContainer(keyedBy: FieldKeys.self, forKey: .fields)
        self.id = try fieldContainer.decode(StringValue.self, forKey: .id)
        self.uid = try fieldContainer.decode(StringValue.self, forKey: .uid)
        self.videoURL = try fieldContainer.decode(StringValue.self, forKey: .videoURL)
        self.thumbnailURL = try fieldContainer.decode(StringValue.self, forKey: .thumbnailURL)
        self.title = try fieldContainer.decode(StringValue.self, forKey: .title)
        self.videoDescription = try fieldContainer.decode(StringValue.self, forKey: .videoDescription)
        self.githubUrl = try fieldContainer.decode(StringValue.self, forKey: .githubUrl)
        self.blogUrl = try fieldContainer.decode(StringValue.self, forKey: .blogUrl)
        self.hearts = try fieldContainer.decode(IntegerValue.self, forKey: .hearts)
        self.date = try fieldContainer.decode(IntegerValue.self, forKey: .date)
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
    
    func toDomain() -> Reels {
        return Reels(id: id.value,
                     title: title.value,
                     videoDescription: videoDescription.value,
                     githubUrl: githubUrl.value,
                     blogUrl: blogUrl.value,
                     hearts: Int(hearts.value) ?? 0,
                     date: Int(date.value) ?? 0,
                     uid: uid.value,
                     videoURL: videoURL.value,
                     thumbnailURL: thumbnailURL.value)
    }
}
