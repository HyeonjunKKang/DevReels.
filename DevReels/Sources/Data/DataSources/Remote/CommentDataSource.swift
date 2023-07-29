//
//  CommentDataSource.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/29.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift
import Firebase

struct CommentDataSource: CommentDataSourceProtocol {
    
    let fireStore = Firestore.firestore().collection("reels")
    
    func upload(request: CommentRequestDTO) -> Observable<Void> {
        
        return Observable.create { emitter in
            fireStore.document(request.reelsID)
                .collection("comments")
                .document(request.commentID)
                .setData(request.toDictionary()) { _ in
                    Firestore.firestore()
                        .collection("users")
                        .document(request.writerUID)
                        .collection("reels")
                        .document(request.reelsID)
                        .collection("comments")
                        .document(request.commentID)
                        .setData(request.toDictionary()) { _ in
                            emitter.onNext(())
                        }
                }
            return Disposables.create()
        }
    }
    
    func read(reelsID: String) -> Observable<[CommentResponseDTO]> {
        return Observable.create { emitter in
            fireStore.document(reelsID)
                .collection("comments")
                .getDocuments(completion: { snapshot, _ in
                    
                    if let snapshot = snapshot?.documents {
                        let comments = snapshot
                            .map { $0.data() }
                            .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                            .compactMap { try? JSONDecoder().decode(Comment.self, from: $0) }
                            .map { CommentResponseDTO(comment: $0) }
                        emitter.onNext(comments)
                        emitter.onCompleted()
                    }
                })
            return Disposables.create()
        }
    }
    
    func delete(request: CommentRequestDTO) -> Observable<Void> {
        return Observable.create { emitter in
            fireStore.document(request.reelsID)
                .collection("comments")
                .document(request.commentID)
                .delete { _ in
                    emitter.onNext(())
                }
            return Disposables.create()
        }
    }
}
