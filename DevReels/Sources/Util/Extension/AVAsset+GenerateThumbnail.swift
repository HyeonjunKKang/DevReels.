//
//  AVAsset+GenerateThumbnail.swift
//  DevReels
//
//  Created by HoJun on 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import AVFoundation
import RxSwift
import UIKit

extension AVAsset {
    
    func generateThumbnail() -> UIImage? {
        do {
            let imgGenerator = AVAssetImageGenerator(asset: self)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
}
