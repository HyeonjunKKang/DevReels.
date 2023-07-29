//
//  CAGradientLayer+ToImage.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            self.render(in: context)
            let outputImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return outputImage ?? UIImage()
        }
        return UIImage()
    }
}
