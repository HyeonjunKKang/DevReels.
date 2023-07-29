//
//  CommentUploadUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift
import Foundation

struct CommentUploadUseCase: CommentUploadUseCaseProtocol {
    
    var commentRepository: CommentRepositoryProtocol?
    
    func upload(comment: Comment) -> Observable<Void> {
        return commentRepository?.upload(comment: comment) ?? .empty()
    }
    
    func delete(comment: Comment) -> Observable<Void> {
        return commentRepository?.delete(comment: comment) ?? .empty()
    }
}
