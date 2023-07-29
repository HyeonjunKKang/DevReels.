//
//  AppCoordinator.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import Foundation

final class AppCoordinator: BaseCoordinator<Void> {
    let window: UIWindow?
    
    init(_ window: UIWindow?) {
        self.window = window
        super.init(UINavigationController())
    }
    
    private func setup(with window: UIWindow?) {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        window?.backgroundColor = .devReelsColor.backgroundDefault
    }
    
    override func start() -> Observable<Void> {
        setup(with: window)
        showLogin()
        return Observable.never()
    }
    
    private func showLogin() {
        navigationController.setNavigationBarHidden(false, animated: true)
        let login = LoginCoordinator(navigationController)
        coordinate(to: login)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.showTab()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    private func showTab() {
        navigationController.setNavigationBarHidden(true, animated: true)
        let tab = TabCoordinator(navigationController)
        coordinate(to: tab)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.showLogin()
                }
            })
            .disposed(by: disposeBag)
    }
}
