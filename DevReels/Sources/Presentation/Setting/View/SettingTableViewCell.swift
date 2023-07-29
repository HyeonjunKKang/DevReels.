//
//  SettingTableViewCell.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SettingTableViewCell: UITableViewCell, Identifiable {
    
    // MARK: - Components
    
    private let titleLabel = UILabel().then {
        $0.text = "고객센터"
        $0.textColor = .devReelsColor.neutral600
        $0.font = .systemFont(ofSize: 16, weight: .bold)
    }
    
    private let arrowImgaeView = UIImageView().then {
        $0.image = UIImage(systemName: "chevron.right")
        $0.tintColor = .devReelsColor.neutral600
    }
    
    // MARK: - Inits
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configureCell(setting: Setting) {
        titleLabel.text = setting.title
    }
    
    // MARK: - Layout
    
    func layout() {
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
        }
       
        contentView.addSubview(arrowImgaeView)
        
        arrowImgaeView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(20)
        }
    }
}
