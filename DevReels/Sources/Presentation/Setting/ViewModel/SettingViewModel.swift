//
//  SettingViewModel.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum SettingResult {
    case logout
    case back
}

final class SettingViewModel: ViewModel {
    
    // MARK: - InOut
    
    struct Input {
        let viewWillAppear: Observable<Void>
        let logoutButtonTap: Observable<Void>
        let backButtonTap: Observable<Void>
        let selectedSeting: Observable<Setting>
    }
    
    struct Output {
        let settingList: Driver<[Setting]>
        let logoutAlert: Signal<Alert>
    }
    
    // MARK: - Properties
    var settingUsecase: SettingUseCaseProtocol?
    var hyperlinkUseCase: HyperLinkUseCaseProtocol?
    var logoutUseCase: LogoutUseCaseProtocol?
    let settings = BehaviorSubject<[Setting]>(value: [])
    let navigation = PublishSubject<SettingResult>()
    let alert = PublishSubject<Alert>()
    var disposeBag = DisposeBag()
    
    // MARK: - transform
    
    func transform(input: Input) -> Output {
        input.viewWillAppear
            .take(1)
            .withUnretained(self)
            .flatMap { $0.0.settingUsecase?.fetchSetting().asResult() ?? .empty() }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let settings):
                    self?.settings.onNext(settings)
                case .failure:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        input.selectedSeting
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.hyperlinkUseCase?.openSafari(urlString: $0.1.targetURLString)
            })
            .disposed(by: disposeBag)
        
        let logoutAlertSubject = PublishSubject<Bool>()
        
        input.logoutButtonTap
            .map {
                return Alert(title: "로그아웃", message: "로그아웃 하시겠습니까?", observer: logoutAlertSubject.asObserver())
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, alert in
                viewModel.alert.onNext(alert)
            })
            .disposed(by: disposeBag)
        
        logoutAlertSubject
            .withUnretained(self)
            .flatMap {
                $0.0.logoutUseCase?.logout().asResult() ?? .empty()
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.navigation.onNext(.logout)
                case .failure:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        input.backButtonTap
            .subscribe(onNext: {[weak self] in
                self?.navigation.onNext(.back)
            })
            .disposed(by: disposeBag)

        return Output(
            settingList: settings.asDriver(onErrorJustReturn: []),
            logoutAlert: alert.asSignal(onErrorSignalWith: .empty())
        )
    }
}
