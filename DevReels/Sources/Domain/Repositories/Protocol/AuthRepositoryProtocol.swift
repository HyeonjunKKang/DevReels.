//
//  AuthRepositoryProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

import FirebaseAuth

protocol AuthRepositoryProtocol {
    func signIn(with credential: OAuthCredential) -> Observable<Authorization>
}

