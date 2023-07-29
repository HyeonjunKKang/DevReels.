//
//  UIImage+Gradient.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

extension UIImage {
    static func createGradient(color1: UIColor, color2: UIColor, frame: CGRect) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [color1.cgColor, color2.cgColor]
        return gradientLayer.toImage()
    }
}


