//
//  ReelsUseCaseProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/23.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

protocol ReelsUseCaseProtocol {
    func list() -> Observable<[Reels]>
    func fetch(uid: String) -> Observable<[Reels]>
}
