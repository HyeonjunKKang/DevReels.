//
//  CommentInputView.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/29.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then

final class CommentInputView: UIView {
    
    // MARK: - Properties
    
    let userimageView = UIImageView().then {
        $0.image = UIImage(systemName: "figure.run")
        $0.backgroundColor = .white
    }
    
    let textField = UITextField().then {
        $0.leftViewMode = .always
        $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16.0, height: 0.0))
        $0.backgroundColor = .devReelsColor.neutral20
        $0.textColor = .devReelsColor.grayscale50
        $0.placeholder = "  댓글을 남겨주세요."
    }
    
    let inputButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        $0.tintColor = .white
        $0.backgroundColor = .devReelsColor.primary80
    }
    
    // MARK: - Initalizer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        attribute()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        userimageView.clipsToBounds = true
        userimageView.layer.cornerRadius = userimageView.frame.width / 2
        
        inputButton.clipsToBounds = true
        inputButton.layer.cornerRadius = inputButton.frame.width / 2
        
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 20
    }
    
    func layout() {
        
        addSubViews([userimageView, textField, inputButton])
        
        userimageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
        }
        
        textField.snp.makeConstraints {
            $0.width.equalTo(280)
            $0.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(userimageView.snp.trailing).offset(8)
        }
        
        inputButton.snp.makeConstraints {
            $0.height.width.equalTo(30)
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(textField.snp.trailing).offset(8)
        }
    }
    
    func attribute() {
        backgroundColor = .devReelsColor.neutral40
    }
}
