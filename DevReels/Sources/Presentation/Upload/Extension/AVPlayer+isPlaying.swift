//
//  Utilities.swift
//  DevReels
//
//  Created by HoJun on 2023/05/17.
//  Copyright © 2023 DevReels. All rights reserved.
//

import AVFoundation

extension AVPlayer {
    
    var isPlaying: Bool {
        return self.rate != 0 && self.error == nil
    }
}
