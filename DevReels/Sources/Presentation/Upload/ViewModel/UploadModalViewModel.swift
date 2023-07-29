//
//  UploadModalViewModel.swift
//  DevReels
//
//  Created by HoJun on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

enum UploadModalNavigation {
    case back
    case upload
}

final class UploadModalViewModel: ViewModel {
    
    struct Input {
        let itemSelected: Observable<UploadModalItem>
        let closeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let items: Driver<[UploadModalItem]>
    }
    
    var disposeBag = DisposeBag()
    let navigation = PublishSubject<UploadModalNavigation>()

    
    func transform(input: Input) -> Output {

        input.itemSelected
            .map({ item in
                switch item {
                case .uploadVideo:
                    return UploadModalNavigation.upload
                }
            })
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.closeButtonTapped
            .map { UploadModalNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        
        return Output(items: Driver.just(UploadModalItem.allCases))
    }
}
