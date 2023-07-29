//
//  ValidationButton.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit

final class ValidationButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureFont()
        configureRadius()
        configureEnableColor()
        configureDisableColor()
    }
    
    private func configureFont() {
        titleLabel?.font = .systemFont(ofSize: 16)
    }
    
    private func configureRadius() {
        clipsToBounds = true
        layer.cornerRadius = 6
    }
    
    private func configureEnableColor() {
        setBackgroundColor(.devReelsColor.primary90 ?? .orange, for: .normal)
        setTitleColor(.white, for: .normal)
    }
    
    private func configureDisableColor() {
        setBackgroundColor(.devReelsColor.neutral50 ?? .darkGray, for: .disabled)
        setTitleColor(.devReelsColor.neutral300, for: .disabled)
    }
}
