//
//  RxTextView+PlaceHolder.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then

class RxTextView: UITextView {
    
    let placeholder: String
    let disposeBag = DisposeBag()
    let placeholderLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 12)
    }
    
    init(placeholder: String) {
        self.placeholder = placeholder
        super.init(frame: .zero)
        layout()
        bind()
        attribute()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        self.placeholder = "내용을 입력해 주세요."
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        addSubview(placeholderLabel)
        
        placeholderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(3)
            $0.left.equalToSuperview().offset(3)
        }
    }
    
    func bind() {
        
        placeholderLabel.text = placeholder
        
        rx.text
            .subscribe(onNext: { [weak self] in
                if $0?.isEmpty ?? true {
                    self?.placeholderLabel.isHidden = false
                } else {
                    self?.placeholderLabel.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    func attribute(){
        textContainer.maximumNumberOfLines = 5
    }
}
