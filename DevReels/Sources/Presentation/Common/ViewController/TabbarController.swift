//
//  TabbarController.swift
//  DevReels
//
//  Created by HoJun on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

final class TabbarController: UITabBarController, UITabBarControllerDelegate {
    
    let selectedUploadTab = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 1 {
            selectedUploadTab.onNext(())
            return false
        }
        return true
    }
}
