//
//  VideoDetailsViewModel.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import AVFoundation
import UIKit
import RxSwift
import RxCocoa

enum VideoDetailsNavigation {
    case finish
    case back
}

final class VideoDetailsViewModel: ViewModel {
    
    struct Input {
        let backButtonTapped: Observable<Void>
        let title: Observable<String>
        let description: Observable<String>
        let urlValidation: Observable<Bool>
        let githubUrlString: Observable<String>
        let blogUrlString: Observable<String>
        let uploadButtonTapped: Observable<Void>
    }
    
    struct Output {
        let uploadButtonEnabled: Driver<Bool>
        let thumbnailImage: UIImage?
    }
    
    var uploadReelsUsecase: UploadReelsUsecaseProtocol?
    var disposeBag = DisposeBag()
    let navigation = PublishSubject<VideoDetailsNavigation>()
    
    var selectedVideoURL: URL?
        
    private var videoData: Data?
    
    func transform(input: Input) -> Output {
        guard let url = selectedVideoURL,
              let thumbnaiImage = AVAsset(url: url).generateThumbnail(),
              let thumbnailData = thumbnaiImage.jpegData(compressionQuality: 0.5),
              let videoData = try? Data(contentsOf: url) else {
            fatalError("Error: Invalid VideoURL")
        }
        
        let reels = Observable
            .combineLatest(input.title,
                           input.description,
                           input.githubUrlString,
                           input.blogUrlString
            )
            .map {
                let id = UUID().uuidString
                return Reels(id: id,
                             title: $0.0,
                             videoDescription: $0.1,
                             githubUrl: $0.2,
                             blogUrl: $0.3
                )
            }
        
        input.backButtonTapped
            .map { VideoDetailsNavigation.back }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input
            .uploadButtonTapped
            .withLatestFrom(reels)
            .withUnretained(self)
            .flatMap { viewModel, reels in
                viewModel.uploadReelsUsecase?.upload(reels: reels,
                                                     video: videoData,
                                                     thumbnailImage: thumbnailData).asResult() ?? .empty()
            }
            .withUnretained(self)
            .subscribe(onNext: { viewModel, result in
                switch result {
                case .success:
                    viewModel.navigation.onNext(.finish)
                case .failure(let error):
                    print(error)
                }
            })
        
        let uploadButtonEnabled = Observable.combineLatest(
            input.title.map { !$0.isEmpty },
            input.description.map { !$0.isEmpty },
            input.urlValidation
        ) {
            $0 && $1 && $2
        }
        
        return Output(uploadButtonEnabled: uploadButtonEnabled.asDriver(onErrorJustReturn: false),
                      thumbnailImage: thumbnaiImage)
    }
}
