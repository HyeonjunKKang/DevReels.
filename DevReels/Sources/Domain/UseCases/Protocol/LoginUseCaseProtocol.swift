//
//  LoginUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/17.
//  Copyright © 2023 DevReels. All rights reserved.
//
import RxSwift
import FirebaseAuth

protocol LoginUseCaseProtocol {
    func singIn(with credential: OAuthCredential) -> Observable<Void>
    func exist() -> Observable<Bool>
}
