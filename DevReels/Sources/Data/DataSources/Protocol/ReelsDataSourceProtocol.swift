//
//  ReelsDataSourceProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol ReelsDataSourceProtocol {
    func list() -> Observable<Documents<[ReelsResponseDTO]>>
    func upload(request: ReelsRequestDTO) -> Observable<Void>
    func uploadFile(type: ReelsDataSource.FileType, uid: String, file: Data) -> Observable<URL>
    func fetch(uid: String) -> Observable<[ReelsResponseDTO]>
    func update(reels: Reels) -> Observable<Void>
}
