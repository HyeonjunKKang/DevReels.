//
//  ReelsCoordinator.swift
//  DevReels
//
//  Created by Jerry on 2023/06/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

enum ReelsCoordinatorResult {
    case finish
}

final class ReelsCoordinator: BaseCoordinator<ReelsCoordinatorResult> {
    
    private let finish = PublishSubject<ReelsCoordinatorResult>()
    
    override func start() -> Observable<ReelsCoordinatorResult> {
        showReels()
//        return Observable.never()
//        showReels()
        return finish
            .do(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.pop(animated: false)
                }
            })
    }
    
    func showReels() {
        guard let viewModel = DIContainer.shared.container.resolve(ReelsViewModel.self) else { return }
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.finish.onNext(.finish)
                case .comments(let data):
                    self?.showComment(data)
                }
            })
            .disposed(by: disposeBag)
        let viewController = ReelsViewController(viewModel: viewModel)
        push(viewController, animated: true, isRoot: true)
    }
    
    func showComment(_ reels: Reels) {
        guard let viewModel = DIContainer.shared.container.resolve(CommentViewModel.self) else { return }
        viewModel.reels = reels
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .back:
                    self?.setTabBarHidden(false)
                    
                    self?.setNavigationBarHidden(true, animated: false)
                    self?.navigationController.dismiss(animated: true)
                case let .profile(user):
                    self?.showProfile(user: user)
                    self?.navigationController.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        let viewController = CommentViewController(viewModel: viewModel)
        viewController.modalPresentationStyle = .pageSheet
        
        if #available(iOS 15.0, *) {
            guard let sheet = viewController.sheetPresentationController else { return }
            if #available(iOS 16.0, *) {
                sheet.detents = [
                    .custom(resolver: { _ in
                        return 540
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
    
    func showProfile(user: User) {
        guard let viewModel = DIContainer.shared.container.resolve(ProfileViewModel.self) else { return }
        viewModel.type.onNext(.other(user))
        
        viewModel.navigation
            .subscribe(onNext: { [weak self] in
                switch $0 {
                case .finish:
                    self?.pop(animated: true)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        let profile = ProfileViewController(viewModel: viewModel)
        push(profile, animated: true)
    }
}
