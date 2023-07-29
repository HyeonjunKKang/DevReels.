//
//  UrlTextField.swift
//  DevReels
//
//  Created by HoJun on 2023/06/10.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then

final class TextField: UIView {
    
    // MARK: Public
    
    enum InputType {
        case normal
        case url
    }

    var placeholder: String? {
        didSet {
            textField.attributedPlaceholder = NSAttributedString(
                string: placeholder ?? "",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.devReelsColor.neutral60]
            )
        }
    }

    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var maxCount: Int = 0 {
        didSet {
            bindTextCount()
        }
    }
        
    // MARK: Private
    
    fileprivate let textField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .devReelsColor.neutral20
        $0.layer.cornerRadius = 6
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.devReelsColor.neutral40?.cgColor
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .devReelsColor.neutral100
        $0.textAlignment = .left
    }
    
    private let validUrlLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .systemRed
        $0.textAlignment = .right
    }
    
    private var disposable: Disposable?
    
    // MARK: Inits
    
    init(isSecure: Bool = false, inputType: InputType = .normal) {
        super.init(frame: .zero)
        switch inputType {
        case .normal:
            break
        case .url:
            bindUrl()
        }
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    
    func setHeight(_ value: CGFloat) {
        textField.snp.makeConstraints {
            $0.height.equalTo(value)
        }
    }
    
    func removeText() {
        textField.text = ""
    }
    
    private func bindUrl() {
        disposable = textField.rx.text
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if let text {
                    owner.checkUrlValid(text)
                }
            })
    }
    
    private func bindTextCount() {
        disposable = textField.rx.text
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if let text {
                    owner.limitTextCount(text)
                }
            })
    }
    
    private func checkUrlValid(_ text: String) {
        if let url = URL(string: text),
           UIApplication.shared.canOpenURL(url) {
            validUrlLabel.text = nil
        } else {
            validUrlLabel.text = "올바르지 않은 URL 형식입니다."
        }
    }
    
    private func limitTextCount(_ text: String) {
        if let str = textField.text?.prefix(maxCount) {
            textField.text = String(str)
        }
    }
    
    private func layout() {
        layoutContainerView()
        layoutStackView()
        layoutTextField()
    }
    
    private func layoutContainerView() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func layoutStackView() {
        [titleLabel, validUrlLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(12)
        }
    }
    
    private func layoutTextField() {
        addSubview(textField)
        textField.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(12)
            make.top.equalTo(stackView.snp.bottom).offset(4)
        }
    }
}

extension Reactive where Base: TextField {
    
    var text: ControlProperty<String?> {
        return base.textField.rx.text
    }
    
    var isValidURL: Observable<Bool> {
        return base.textField.rx.text
            .map { urlString in
                guard let urlString = urlString else { return false }
                guard let url = URL(string: urlString) else { return false }
                return UIApplication.shared.canOpenURL(url)
            }
            .share(replay: 1)
    }
}
