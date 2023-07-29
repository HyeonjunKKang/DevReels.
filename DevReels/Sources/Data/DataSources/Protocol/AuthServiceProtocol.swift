//
//  AuthServiceProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol AuthServiceProtocol {
    func login(_ request: OAuthAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO>
}
