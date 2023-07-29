//
//  EditProfileUseCase.swift
//  DevReels
//
//  Created by HoJun on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

struct EditProfileUseCase: EditProfileUseCaseProtocol {
    
    var userRepository: UserRepositoryProtocol?
    
    func loadProfile() -> Observable<User> {
        return userRepository?.currentUser() ?? .empty()
    }
    
    func setProfile(profile: Profile) -> Observable<Void> {
        let imageData: Data? = profile.profileImage?.jpegData(compressionQuality: 0.5)
        return userRepository?.set(profile: profile, imageData: imageData) ?? .empty()
    }
}
