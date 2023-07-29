//
//  FBAuthService.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/17.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxDevReelsYa

struct FBAuthService: AuthServiceProtocol {
    private let provider: Provider
    
    init() {
        self.provider = Provider.default
    }
    
    func login(_ request: OAuthAuthorizationRequestDTO) -> Observable<AuthorizationResponseDTO> {
        return provider.request(AuthTarget.login(request))
    }
}

enum AuthTarget{
    case login(OAuthAuthorizationRequestDTO)
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return Network.authBaseURLString
    }

    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        }
    }

    var header: HTTPHeaders {
        return ["Content-Type": "application/json"]
    }

    var path: String {
        switch self {
        case .login:
            return "/accounts:signInWithIdp?key=\(Network.webAPIKey)"
        }
    }

    var parameters: RequestParams? {
        switch self {
        case let .login(request):
            return .body(request)
        }
    }

    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }


}
