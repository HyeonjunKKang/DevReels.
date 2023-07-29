//
//  ReelsUseCase.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct ReelsUseCase: ReelsUseCaseProtocol {
    
    var reelsRepository: ReelsRepositoryProtocol?
    var userRepository: UserRepositoryProtocol?
    
    func list() -> Observable<[Reels]> {
        return reelsRepository?.list() ?? .empty()
    }
    
    func fetch(uid: String) -> Observable<[Reels]> {
        return reelsRepository?.fetch(uid: uid) ?? .empty()
    }
}
