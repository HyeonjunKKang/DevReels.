//
//  EditProfileUseCaseProtocol.swift
//  DevReels
//
//  Created by HoJun on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol EditProfileUseCaseProtocol {
    func loadProfile() -> Observable<User>
    func setProfile(profile: Profile) -> Observable<Void>
}
