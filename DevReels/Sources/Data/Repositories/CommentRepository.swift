//
//  CommentRepository.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct CommentRepository: CommentRepositoryProtocol {
    var commentDataSource: CommentDataSourceProtocol?
    private let disposeBag = DisposeBag()
    
    func upload(comment: Comment) -> Observable<Void> {
        let request = CommentRequestDTO(comment: comment)
        
        return commentDataSource?.upload(request: request) ?? .empty()
    }
    
    func fetch(reelsID: String) -> Observable<[Comment]> {
        return commentDataSource?.read(reelsID: reelsID)
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
    
    func delete(comment: Comment) -> Observable<Void> {
        let request = CommentRequestDTO(deleteComment: comment)
        
        return commentDataSource?.delete(request: request) ?? .empty()
    }
}
