//
//  LogoutUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/26.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol LogoutUseCaseProtocol {
    func logout() -> Observable<Void>
}
