//
//  ToggleBar.swift
//  DevReels
//
//  Created by HoJun on 2023/07/05.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class ToggleBar: UIView {
    
    // MARK: Public

    var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
        
    // MARK: Private

    private let imageView = UIImageView().then {
        $0.tintColor = .devReelsColor.neutral100
    }

    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .devReelsColor.neutral100
        $0.textAlignment = .left
    }
    
    fileprivate let toggleSwitch = UISwitch().then {
        $0.onTintColor = .devReelsColor.primary90
    }
    
    private var disposable: Disposable?
    
    // MARK: Inits
    
    init() {
        super.init(frame: .zero)
        setup()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func setup() {
        backgroundColor = .devReelsColor.neutral20
        layer.cornerRadius = 6
        layer.borderWidth = 1
        layer.borderColor = UIColor.devReelsColor.neutral40?.cgColor
    }
    
    private func layout() {
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.bottom.equalToSuperview().inset(12)
            make.width.equalTo(imageView.snp.height)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(12)
            make.top.bottom.equalToSuperview().inset(12)
        }
        
        addSubview(toggleSwitch)
        toggleSwitch.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(12)
        }
    }
}

extension Reactive where Base: ToggleBar {
    
    var isOn: Observable<Bool> {
        return base.toggleSwitch.rx.isOn.asObservable()
    }
}
