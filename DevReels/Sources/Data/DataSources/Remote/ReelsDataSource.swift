//
//  ReelsDataSource.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxDevReelsYa
import RxSwift
import Firebase

struct ReelsDataSource: ReelsDataSourceProtocol {
    
    enum FileType: String {
        case video = "videos"
        case image = "images"
        
        var contentTypeString: String {
            switch self {
            case .video:
                return "video/mp4"
            case .image:
                return "image/jpeg"
            }
        }
    }
    
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func list() -> Observable<Documents<[ReelsResponseDTO]>> {
        return provider.request(ReelsTarget.list).debug()
    }
    
    func upload(request: ReelsRequestDTO) -> Observable<Void> {
        let request = Observable.zip(
            provider.request(ReelsTarget.uploadToReels(request)),
            provider.request(ReelsTarget.uploadToUserReels(request))
        )
            .map { _, _ in }
        return request
    }
    
    func uploadFile(type: FileType, uid: String, file: Data) -> Observable<URL> {
        return Observable.create { emitter in
            
            let fileName = UUID().uuidString + String(Date().timeIntervalSince1970)
            let metaData = StorageMetadata()
            metaData.contentType = type.contentTypeString
            
            let ref = Storage.storage().reference().child(uid).child(type.rawValue).child(fileName)
            ref.putData(file, metadata: metaData) { _, error in
                if let error = error {
                    emitter.onError(error)
                    return
                }
                ref.downloadURL { url, error in
                    guard let url else {
                        if let error = error {
                            emitter.onError(error)
                        }
                        return
                    }
                    emitter.onNext(url)
                    emitter.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
  
    func fetch(uid: String) -> Observable<[ReelsResponseDTO]> {
        return Observable.create { emitter in
            Firestore.firestore()
                .collection("users")
                .document(uid)
                .collection("reels")
                .getDocuments(completion: { snapshot, _ in
                    if let snapshot = snapshot?.documents {
                        let reels = snapshot
                            .map { $0.data() }
                            .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                            .compactMap { try? JSONDecoder().decode(Reels.self, from: $0) }
                            .map { ReelsResponseDTO(reels: $0)}
                        emitter.onNext(reels)
                        emitter.onCompleted()
                    }
                })
            return Disposables.create()
        }
    }

    func update(reels: Reels) -> Observable<Void> {
        Observable .create { emitter in
            Firestore.firestore()
                .collection("reels")
                .document(reels.id)
                .updateData(reels.toDictionary())
            return Disposables.create()
        }
    }
}

enum ReelsTarget {
    case list
    case uploadToReels(ReelsRequestDTO)
    case uploadToUserReels(ReelsRequestDTO)
}

extension ReelsTarget: TargetType {
    var baseURL: String {
        return Network.baseURLString + "/documents"
    }
    
    var method: HTTPMethod {
        switch self {
        case .list:
            return .get
        case .uploadToReels, .uploadToUserReels:
            return .post
        }
    }
    
    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }
    
    var path: String {
        switch self {
        case .uploadToReels(let reels):
            return "/reels/?documentId=\(reels.id.value)"
        case .uploadToUserReels(let reels):
            return "/users/\(reels.uid.value)/reels/?documentId=\(reels.id.value)"
        default:
            return "/reels"
        }
    }
    
    var parameters: RequestParams? {
        switch self {
        case .list:
            return nil
        case .uploadToReels(let reels), .uploadToUserReels(let reels):
            return .body(reels)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
