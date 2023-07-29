//
//  ProfileCellViewModel.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/19.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileCellViewModel: ViewModel {
    
    struct Input {
        let reels: Observable<Reels>
    }
    
    struct Output {
        let commentCount: Driver<String>
    }
    
    var disposeBag = DisposeBag()
    var commentCount = PublishSubject<String>()
    
    var commentListUseCase: CommentListUseCaseProtocol?
    
    func transform(input: Input) -> Output {
        
        input.reels
            .withUnretained(self)
            .flatMap { $0.0.commentListUseCase?.commentList(reelsID: $0.1.id).asResult() ?? .empty() }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let data):
                    self?.commentCount.onNext("\(data.count)")
                case .failure:
                    break
                }
            })
            .disposed(by: disposeBag)
        
        return Output(commentCount: commentCount.asDriver(onErrorJustReturn: "0"))
    }
}

