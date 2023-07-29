//
//  TokenRepositoryProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/21.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol TokenRepositoryProtocol {
    func save(_ auth: Authorization) -> Observable<Authorization>
    func load() -> Observable<Authorization>
    func delete() -> Observable<Void>
}
