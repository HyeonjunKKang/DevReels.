//
//  RxUIImageView.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxUIImageView: UIImageView {
    private let tapGesture = UITapGestureRecognizer()
    private let tapSubject = PublishSubject<Void>()
    
    var tapEvent: ControlEvent<Void> {
        return ControlEvent(events: tapSubject.asObservable())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureGesture() {
        isUserInteractionEnabled = true
        addGestureRecognizer(tapGesture)
        tapGesture.addTarget(self, action: #selector(handleTapGesture))
    }
    
    @objc private func handleTapGesture() {
        tapSubject.onNext(())
    }
}
