//
//  CountTextView.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class CountTextView: UIView {
    
    // MARK: Public
    
    var placeholder: String? {
        didSet {
            textView.placeholder = placeholder
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var maxCount: Int = -1 {
        didSet {
            update()
        }
    }
    
    // MARK: Private
    
    fileprivate let textView = TextView()
    
    private let containerView = UIView().then {
        $0.backgroundColor = .devReelsColor.neutral20
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.devReelsColor.neutral40?.cgColor
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textAlignment = .left
        $0.textColor = .devReelsColor.neutral100
    }
    
    private let countLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textAlignment = .right
        $0.textColor = .devReelsColor.neutral100
    }
    
    private var disposable: Disposable?
    
    // MARK: Inits
    
    init() {
        super.init(frame: .zero)
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    private func bind() {
        disposable = textView.rx.text
            .subscribe { [weak self] _ in
                self?.update()
            }
    }
    
    private func update() {
        let maxCount = maxCount < 0 ? Int.max : maxCount
        if let str = textView.text?.prefix(maxCount) {
            textView.text = String(str)
        }
        countLabel.isHidden = maxCount == Int.max ? true : false
        countLabel.text = "\(textView.text?.count ?? 0)/\(maxCount)"
    }
    
    private func layout() {
        layoutContainerView()
        layoutTitleLabel()
        layoutTextView()
        layoutCountLabel()
    }
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(24)
        }
    }
    
    private func layoutTitleLabel() {
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(12)
        }
    }
    
    private func layoutTextView() {
        containerView.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
    
    private func layoutCountLabel() {
        addSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.bottom.trailing.equalToSuperview()
        }
    }
}

extension Reactive where Base: CountTextView {
    
    var text: ControlProperty<String?> {
        return base.textView.rx.text
    }
}
