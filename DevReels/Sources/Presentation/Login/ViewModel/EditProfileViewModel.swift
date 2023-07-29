//
//  CreateUserViewModel.swift
//  DevReels
//
//  Created by HoJun on 2023/07/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum EditProfileNavigation {
    case finish
    case back
}

final class EditProfileViewModel: ViewModel {
    
    enum EditType {
        case create
        case edit
    }
    
    struct Input {
        let name: Observable<String>
        let introduce: Observable<String>
        let profileImage: Observable<UIImage>
        let urlValidation: Observable<Bool>
        let githubUrlString: Observable<String>
        let blogUrlString: Observable<String>
        let completeButtonTapped: Observable<Void>
        let backButtonTapped: Observable<Void>
    }
    
    struct Output {
        let originName: Driver<String>
        let originIntroduce: Driver<String>
        let originProfileImage: Driver<UIImage?>
        let inputValidation: Driver<Bool>
        let type: Driver<EditType>
    }
    
    var disposeBag = DisposeBag()
    var editProfileUseCase: EditProfileUseCaseProtocol?
    let navigation = PublishSubject<EditProfileNavigation>()
    let type = BehaviorSubject<EditType>(value: .edit)
    private let profile = PublishSubject<Profile>()
    private let user = BehaviorSubject<User?>(value: nil)
    private let name = BehaviorSubject<String>(value: "")
    private let introduce = BehaviorSubject<String>(value: "")
    private let image = BehaviorSubject<UIImage?>(value: nil)
    private let inputValidation = BehaviorSubject<Bool>(value: false)
    private let githubUrlString = BehaviorSubject<String>(value: "")
    private let blogUrlString = BehaviorSubject<String>(value: "")
    private let alert = PublishSubject<Alert>()
    
    func transform(input: Input) -> Output {
        bindUser(input: input)
        bindImage(input: input)
        bindScene(input: input)
        
        return Output(originName: name.asDriver(onErrorJustReturn: ""),
                      originIntroduce: introduce.asDriver(onErrorJustReturn: ""),
                      originProfileImage: image.asDriver(onErrorJustReturn: nil),
                      inputValidation: inputValidation.asDriver(onErrorJustReturn: false),
                      type: type.asDriver(onErrorJustReturn: .edit))
    }
    
    private func bindUser(input: Input) {
        type
            .filter { $0 == .edit }
            .withUnretained(self)
            .flatMap { viewModel, _ in
                viewModel.editProfileUseCase?.loadProfile().asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe { viewModel, result in
                switch result {
                case .success(let user):
                    viewModel.user.onNext(user)
                case .failure:
                    // TODO: 유저 정보 가져오기 실패 처리
                    break
                }
            }
            .disposed(by: disposeBag)
        
        Observable.merge(user.compactMap { $0?.nickName }, input.name)
            .bind(to: name)
            .disposed(by: disposeBag)
    
        Observable.merge(user.compactMap { $0?.introduce }, input.introduce)
            .bind(to: introduce)
            .disposed(by: disposeBag)
        
        Observable.merge(user.compactMap { $0?.githubURL }, input.githubUrlString )
            .bind(to: githubUrlString)
            .disposed(by: disposeBag)
        
        Observable.merge(user.compactMap { $0?.blogURL }, input.blogUrlString )
            .bind(to: blogUrlString)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(
            input.urlValidation,
            name.map { (2...15).contains($0.count) }
        )
        .map { $0.0 && $0.1 }
        .bind(to: inputValidation)
        .disposed(by: disposeBag)
        
        Observable.combineLatest(
            name,
            introduce,
            image,
            githubUrlString,
            blogUrlString
        )
        .map {
            Profile(nickName: $0.0,
                    introduce: $0.1,
                    profileImage: $0.2,
                    githubURLString: $0.3,
                    blogURLString: $0.4
            )
        }
        .bind(to: profile)
        .disposed(by: disposeBag)
    }
    
    private func bindImage(input: Input) {
        Observable
            .merge(
                user
                    .compactMap { $0?.profileImageURLString }
                    .compactMap { URL(string: $0) }
                    .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                    .compactMap { try? Data(contentsOf: $0) }
                    .observe(on: MainScheduler.asyncInstance)
                    .compactMap { UIImage(data: $0) },
                input.profileImage
            )
            .debug()
            .bind(to: image)
            .disposed(by: disposeBag)
    }
    
    private func bindScene(input: Input) {
        
        input
            .completeButtonTapped
            .withLatestFrom(profile)
            .withUnretained(self)
            .flatMap { viewModel, profile in
                return viewModel.editProfileUseCase?.setProfile(profile: profile) ?? .empty()
            }
            .map { EditProfileNavigation.finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input
            .backButtonTapped
            .map { EditProfileNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
    }
}
