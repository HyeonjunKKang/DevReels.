//
//  ToggleTextfield.swift
//  DevReels
//
//  Created by HoJun on 2023/07/05.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Then
import SnapKit

final class ToggleUrlTextfield: UIView {
    
    // MARK: Publics
    
    var toggleBarTitle: String? {
        didSet {
            toggleBar.title = toggleBarTitle
        }
    }
    
    var toggleBarImage: UIImage? {
        didSet {
            toggleBar.image = toggleBarImage
        }
    }
    
    var textFieldTitle: String? {
        didSet {
            urlTextField.title = textFieldTitle
        }
    }
    
    var placeholder: String? {
        didSet {
            urlTextField.placeholder = placeholder
        }
    }
    
    var scrollview: UIScrollView?
    
    // MARK: Privates
    
    fileprivate let toggleBar = ToggleBar().then {
        $0.image = UIImage(systemName: "square.and.arrow.up")
        $0.title = "Github 링크 추가하기"
    }
    
    fileprivate let urlTextField = TextField(inputType: .url).then {
        $0.placeholder = "영상 관련 링크를 입력해주세요"
        $0.title = "링크"
    }
    
    private lazy var stackView = UIStackView().then {
        $0.addArrangedSubview(toggleBar)
        $0.axis = .vertical
        $0.spacing = 4
    }
    
    private var disposeBag = DisposeBag()
    
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
    
    private func layout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func bind() {
        toggleBar.rx.isOn
            .subscribe { [weak self] isOn in
                if isOn {
                    self?.addTextField()
                } else {
                    self?.removeTextField()
                    self?.urlTextField.removeText()
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func addTextField() {
        guard let toggleBar = stackView.arrangedSubviews.last else { return }
        let nextEntryIndex = stackView.arrangedSubviews.count
        
        let newEntryView = urlTextField
        newEntryView.isHidden = true
        stackView.insertArrangedSubview(newEntryView, at: nextEntryIndex)

        if let scrollview {
            let offset = CGPoint(x: scrollview.contentOffset.x, y: scrollview.contentOffset.y + toggleBar.bounds.size.height)
            
            UIView.animate(withDuration: 0.25) {
                newEntryView.isHidden = false
                scrollview.contentOffset = offset
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                newEntryView.isHidden = false
            }
        }
    }
    
    private func removeTextField() {
        UIView.animate(withDuration: 0.25, animations: {
            self.urlTextField.isHidden = true
        }, completion: { _ in
            self.urlTextField.removeFromSuperview()
        })
    }
}

extension Reactive where Base: ToggleUrlTextfield {
    
    var validSubmit: Observable<Bool> {
        return Observable.combineLatest(base.toggleBar.rx.isOn,
                                 base.urlTextField.rx.isValidURL)
        .map { (isOn, isValidURL) in
            isOn ? isValidURL : true
        }
    }
    
    var urlString: ControlProperty<String?> {
        return base.urlTextField.rx.text
    }
}
