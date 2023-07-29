//
//  RoundProfileImageView.swift
//  DevReels
//
//  Created by HoJun on 2023/07/18.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class RoundProfileImageView: UIImageView {

    init(_ length: Double) {
        super.init(frame: .zero)
        layout(length)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPhoto(_ image: UIImage) {
        self.image = image
    }
    
    private func layout(_ length: Double) {
        contentMode = .scaleAspectFill

        snp.makeConstraints {
            $0.width.height.equalTo(length)
        }
        
        layer.cornerRadius = length / 2
        clipsToBounds = true
    }
}
