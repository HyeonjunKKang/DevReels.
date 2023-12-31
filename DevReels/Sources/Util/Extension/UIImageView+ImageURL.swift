//
//  UIImageView+ImageURL.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit


extension UIImageView {
    
    private struct AssociatedKeys {
        static var imageURL: UInt8 = 0
    }
    
    @nonobjc static var imageCache = NSCache<NSString, AnyObject>()
    
    public var imageURL: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.imageURL) as? String
        }
        set(newValue) {
            guard let urlString = newValue else {
                objc_setAssociatedObject(self, &AssociatedKeys.imageURL, newValue, .OBJC_ASSOCIATION_RETAIN)
                image = nil
                return
            }
            objc_setAssociatedObject(self, &AssociatedKeys.imageURL, newValue, .OBJC_ASSOCIATION_RETAIN)
            if let image = UIImageView.imageCache.object(
                forKey: "\((urlString as NSString).hash)" as NSString) as? UIImage {
                self.image = image
                return
            }
            DispatchQueue.global().async { [weak self] in
                guard let url = URL(string: urlString as String) else {
                    return
                }
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                let image = UIImage(data: data)
                guard let fetchedImage = image else {
                    return
                }
                DispatchQueue.main.async {
                    UIImageView.imageCache.setObject(fetchedImage, forKey: "\(urlString.hash)" as NSString)
                    guard let pastImageUrl = self?.imageURL,
                          url.absoluteString == pastImageUrl else {
                        self?.image = nil
                        return
                    }
                    let animation = CATransition()
                    animation.type = CATransitionType.fade
                    animation.duration = 0.3
                    self?.layer.add(animation, forKey: "transition")
                    self?.image = fetchedImage
                }
            }
        }
    }
    
    func setImageColor(color: UIColor) {
        guard let tempImage = image?.withRenderingMode(.alwaysTemplate) else { return }
        image = tempImage
        tintColor = color
    }
}
