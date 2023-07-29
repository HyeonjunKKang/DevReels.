//
//  UploadReelsUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/06/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct UploadReelsUseCase: UploadReelsUsecaseProtocol {
    
    var reelsRepository: ReelsRepositoryProtocol?
    var tokenRepository: TokenRepositoryProtocol?
    
    func upload(reels: Reels, video: Data, thumbnailImage: Data) -> Observable<Void> {
        tokenRepository?.load()
            .compactMap { $0.localId }
            .flatMap { reelsRepository?.upload(reels: reels,
                                               uid: $0,
                                               video: video,
                                               thumbnailImage: thumbnailImage) ?? .empty() } ?? .empty()
            
    }
}
