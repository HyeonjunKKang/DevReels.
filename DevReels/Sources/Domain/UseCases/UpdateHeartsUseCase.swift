//
//  UpdateHeartsUseCase.swift
//  DevReels
//
//  Created by Jerry on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UpdateHeartsUseCase: UpdateHeartsUseCaseProtocol {
    var userRepository: UserRepositoryProtocol?
    var reelsRepository: ReelsRepositoryProtocol?
    
    private let disposeBag = DisposeBag()
    
    // TODO: - 업데이트해야하는 데이터 아직 안넣었음
    func updateUser(user: User, reels: Reels) {
        
    }
    
    func updateReels(hearts: Int, reels: Reels) {
        
    }
    
    func addHeart(user: User, reels: Reels, hearts: Int) {
        let user = User(identifier: user.identifier,
                        profileImageURLString: user.profileImageURLString,
                        nickName: user.nickName,
                        githubURL: user.githubURL,
                        blogURL: user.blogURL,
                        introduce: user.introduce,
                        likedList: user.likedList + [reels.id],
                        uid: user.uid)
        let reels = Reels(id: reels.id,
                          title: reels.title,
                          videoDescription: reels.videoDescription,
                          githubUrl: reels.githubUrl,
                          blogUrl: reels.blogUrl,
                          hearts: reels.hearts + 1,
                          date: reels.date,
                          uid: reels.uid,
                          videoURL: reels.videoURL,
                          thumbnailURL: reels.thumbnailURL)
        
        userRepository?.update(user: user)
        reelsRepository?.update(reels: reels)
    }
    
    func removeHeart(user: User, reels: Reels, hearts: Int) {
        let user = User(identifier: user.identifier,
                        profileImageURLString: user.profileImageURLString,
                        nickName: user.nickName,
                        githubURL: user.githubURL,
                        blogURL: user.blogURL,
                        introduce: user.introduce,
                        likedList: user.likedList.filter { $0 != reels.id },
                        uid: user.uid)
        let reels = Reels(id: reels.id,
                          title: reels.title,
                          videoDescription: reels.videoDescription,
                          githubUrl: reels.githubUrl,
                          blogUrl: reels.blogUrl,
                          hearts: reels.hearts - 1,
                          date: reels.date,
                          uid: reels.uid,
                          videoURL: reels.videoURL,
                          thumbnailURL: reels.thumbnailURL)
        
        userRepository?.update(user: user)
        reelsRepository?.update(reels: reels)
    }
}
