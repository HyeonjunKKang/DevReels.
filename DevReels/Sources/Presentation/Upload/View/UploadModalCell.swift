//
//  UploadModalCell.swift
//  DevReels
//
//  Created by HoJun on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class UploadModalCell: UITableViewCell, Identifiable {
    
    private let titleLabel = UILabel().then {
        $0.textColor = .white
    }
    
    private let leftIcon = UIImageView().then {
        $0.tintColor = .white
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(modalItem: UploadModalItem) {
        titleLabel.text = modalItem.title
        leftIcon.image = modalItem.image
    }
    
    private func layout() {
        
        contentView.addSubview(leftIcon)
        leftIcon.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.width.equalTo(leftIcon.snp.height)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalTo(leftIcon.snp.trailing).offset(20)
        }
    }
}
