//
//  UpdateHeartsUseCaseProtocol.swift
//  DevReels
//
//  Created by Jerry on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol UpdateHeartsUseCaseProtocol {
    func addHeart(user: User, reels: Reels, hearts: Int)
    func removeHeart(user: User, reels: Reels, hearts: Int)
}
