//
//  UploadModalItem.swift
//  DevReels
//
//  Created by HoJun on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

enum UploadModalItem: CaseIterable {
    case uploadVideo
    
    var title: String {
        switch self {
        case .uploadVideo:
            return "동영상 업로드"
        }
    }
    
    var image: UIImage {
        switch self {
        case .uploadVideo:
            return UIImage(systemName: "arrow.up.to.line.circle.fill") ?? UIImage()
        }
    }
}
