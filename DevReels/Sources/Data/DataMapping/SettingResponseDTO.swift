//
//  SettingResponseDTO.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

struct SettingResponseDTO: Decodable {
    let title: String
    let targetURLString: String
    let order: String
    
    init(setting: Setting) {
        self.title = setting.title
        self.targetURLString = setting.targetURLString
        self.order = setting.order
    }
    
    func toDomain() -> Setting {
        return Setting(
            title: title,
            targetURLString: targetURLString,
            order: order
        )
    }
}
