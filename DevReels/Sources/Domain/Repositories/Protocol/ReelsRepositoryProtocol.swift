//
//  ReelsRepositoryProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift
import Foundation

protocol ReelsRepositoryProtocol {
    func list() -> Observable<[Reels]>
    func upload(reels: Reels, uid: String, video: Data, thumbnailImage: Data) -> Observable<Void>
    func fetch(uid: String) -> Observable<[Reels]>
    func update(reels: Reels)
}
