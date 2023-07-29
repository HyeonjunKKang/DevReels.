//
//  SettingCoordinator.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

enum SettingCoordinatorResult {
    case logout
    case back
}

final class SettingCoordinator: BaseCoordinator<SettingCoordinatorResult> {
    
    let finish = PublishSubject<SettingCoordinatorResult>()
    
    override func start() -> Observable<SettingCoordinatorResult> {
        showSetting()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .back: self?.pop(animated: true)
                case .logout: self?.pop(animated: false)
                }
            })
    }
    
    func showSetting() {
        guard let viewModel = DIContainer.shared.container.resolve(SettingViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.finish.onNext(.back)
                case .logout:
                    self?.finish.onNext(.logout)
                }
            })
        
        let viewController = SettingViewController(viewModel: viewModel)
        push(viewController, animated: true)
    }
    
}
