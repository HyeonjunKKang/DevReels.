//
//  KeychainProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

protocol KeychainProtocol{
    func add(_ query: [String: Any]) -> OSStatus
    func search(_ query: [String: Any]) -> Data?
    func update(_ query: [String: Any], with attributes: [String: Any]) -> OSStatus
    func delete(_ query: [String: Any]) -> OSStatus
}
