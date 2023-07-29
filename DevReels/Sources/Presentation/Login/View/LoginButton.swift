//
//  LoginButton.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

final class LoginButton: UIButton{
    
    // MARK: - Initalizer
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    private func configure(){
        configureRadius()
        configureBackgroundColor()
    }
    
    private func configureRadius(){
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    private func configureBackgroundColor(){
        backgroundColor = .black
    }
}
