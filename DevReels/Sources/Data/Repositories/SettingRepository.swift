//
//  SettingRepository.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

struct SettingRepository: SettingRepositoryProtocol {
    
    var settingDataSource: SettingDataSourceProtocol?
    
    func fetch() -> Observable<[Setting]> {
        return settingDataSource?.fetch()
            .map { $0.map { $0.toDomain() } } ?? .empty()
    }
}
