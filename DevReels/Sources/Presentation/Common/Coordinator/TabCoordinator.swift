//
//  TabCoordinator.swift
//  DevReels
//
//  Created by HoJun on 2023/05/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

import RxSwift

enum TabCoordinatorResult {
    case finish
}

final class TabCoordinator: BaseCoordinator<TabCoordinatorResult> {
    
    enum Tab: Int, CaseIterable {
        case reels
        case upload
        case profile
        
        var title: String {
            switch self {
            case .reels: return "릴스"
            case .upload: return "업로드"
            case .profile: return "프로필"
            }
        }
        
        var image: String {
            switch self {
            case .reels: return "house.fill"
            case .upload: return "plus.circle"
            case .profile: return "person.crop.circle"
            }
        }
    }
    
    private var tabBarController = TabbarController()
    private let finish = PublishSubject<TabCoordinatorResult>()
    
    override func start() -> Observable<TabCoordinatorResult> {
        push(tabBarController, animated: true, isRoot: true)
        setUploadTapAction()
        setup()
        return finish
    }
    
    private func setUploadTapAction() {
        tabBarController.selectedUploadTab
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.showUploadModal()
            })
    }
    
    private func setup() {
        
        var rootViewControllers: [UINavigationController] = []
        
        Tab.allCases.forEach {
            let navigationController = navigationController(tab: $0)
            rootViewControllers.append(navigationController)
            
            switch $0 {
            case .reels: showReels(navigationController)
            case .upload: break
            case .profile: showProfile(navigationController)
            }
        }
        tabBarController.setViewControllers(rootViewControllers, animated: false)
    }
    
    private func navigationController(tab: Tab) -> UINavigationController {
        let navigationController = UINavigationController()
        let tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.image),
            tag: tab.rawValue
        )
        navigationController.tabBarItem = tabBarItem
        navigationController.isNavigationBarHidden = true
        return navigationController
    }
    
    private func showUpload() {
        let child = UploadCoordinator(navigationController)
        coordinate(to: child)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.navigationController.popToRootViewController(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showReels(_ root: UINavigationController) {
        let child = ReelsCoordinator(root)
        coordinate(to: child)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showProfile(_ root: UINavigationController) {
        let child = ProfileCoordinator(root)
        coordinate(to: child)
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func showUploadModal() {
        let viewModel = UploadModalViewModel()
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.navigationController.dismiss(animated: true)
                case .upload:
                    self?.navigationController.dismiss(animated: true)
                    self?.showUpload()
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = UploadModalViewController(viewModel: viewModel)
        
        viewController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            guard let sheet = viewController.sheetPresentationController else { return }
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom(resolver: { _ in
                        return 180
                    })
                ]
            } else {
                sheet.detents = [
                    .medium()
                ]
            }
            navigationController.present(viewController, animated: true)
        }
    }
}
