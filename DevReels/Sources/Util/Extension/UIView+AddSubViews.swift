//
//  UIView+AddSubViews.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

extension UIView{
    func addSubViews(_ subViews: [UIView]){
        subViews.forEach{ addSubview($0) }
    }
}
