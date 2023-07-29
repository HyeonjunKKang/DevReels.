//
//  ViewController.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.backward")?
            .withTintColor(.devReelsColor.neutral200 ?? .white,
                           renderingMode: .alwaysOriginal), for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .devReelsColor.backgroundDefault
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        layout()
        bind()
    }
    
    func layout() {}
    func bind() {}
}
