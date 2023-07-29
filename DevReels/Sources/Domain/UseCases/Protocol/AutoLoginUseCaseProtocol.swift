//
//  AutoLoginUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

protocol AutoLoginUseCaseProtocol {
    func load() -> Observable<User>
}
