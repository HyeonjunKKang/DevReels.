//
//  KeychainManagerProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

protocol KeychainManagerProtocol {
    func save(key: KeychainKey, data: Data) -> Bool
    func load(key: KeychainKey) -> Data?
    func delete(key: KeychainKey) -> Bool
    func update(key: KeychainKey, data: Data) -> Bool
}
