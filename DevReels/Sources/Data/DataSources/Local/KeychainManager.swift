//
//  KeychainManager.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

enum KeychainKey: String {
    case authorization = "com.devreels.authorization"
}

struct KeychainManager: KeychainManagerProtocol {

    var keychain: KeychainProtocol?

    func save(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue, // 데이터 저장을 위한 키
            kSecValueData as String: data   //저장될 데이터를 Data Type으로
        ]

        let status = keychain?.add(query)
        return status == errSecSuccess ? true : false // status가 errSecSuccess로 저장에 성공하면 true, else false
    }

    func load(key: KeychainKey) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue,
            kSecReturnData as String: true,             // 데이터를 리턴할지
            kSecMatchLimit as String: kSecMatchLimitOne //값이 일치하는 1개의 데이터만
        ]

        return keychain?.search(query)
    }

    func delete(key: KeychainKey) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]

        let status = keychain?.delete(query)
        return status == errSecSuccess ? true : false
    }

    func update(key: KeychainKey, data: Data) -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key.rawValue
        ]

        let attributes: [String: Any] = [
            kSecAttrAccount as String: key.rawValue,
            kSecValueData as String: data
        ]

        let status = keychain?.update(query, with: attributes)
        return status == errSecSuccess ? true : false
    }
}
