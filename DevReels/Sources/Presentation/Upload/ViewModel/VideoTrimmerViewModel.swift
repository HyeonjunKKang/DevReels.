//
//  TrimVideoViewmodel.swift
//  DevReels
//
//  Created by HoJun on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

enum VideoTrimmerNavigation {
    case details(seletedVideoURL: URL)
    case finish
}

final class VideoTrimmerViewModel: ViewModel {
    
    struct Input {
        let isMute: Observable<Bool>
        let nextButtonTapped: Observable<Void>
        let cancelButtonTapped: Observable<Void>
        let selectedVideoURL: Observable<URL>
        let startTime: Observable<CMTime>
        let endTime: Observable<CMTime>
    }
    
    struct Output {
        let nextButtonEnabled: Driver<Bool>
    }
    
    var disposeBag = DisposeBag()
    let navigation = PublishSubject<VideoTrimmerNavigation>()
    let muteSubject = BehaviorSubject<Bool>(value: false)
    
    func transform(input: Input) -> Output {
        
        let trimmingObservable = Observable.combineLatest(input.selectedVideoURL, input.startTime, input.endTime)
        
        input.nextButtonTapped
            .withLatestFrom(trimmingObservable)
            .withUnretained(self)
            .flatMap { $0.trimVideo(sourceURL: $1.0, startTime: $1.1, endTime: $1.2) }
            .observe(on: MainScheduler.instance)
            .map { VideoTrimmerNavigation.details(seletedVideoURL: $0) }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        input.cancelButtonTapped
            .map { VideoTrimmerNavigation.finish }
            .bind(to: navigation)
            .disposed(by: disposeBag)
        
        let nextButtonEnabled = trimmingObservable
            .map { $0.0.isFileURL && $0.1.isValid && $0.2.isValid }
            .asDriver(onErrorJustReturn: false)
            
        return Output(nextButtonEnabled: nextButtonEnabled)
    }
    
    func videoURLToAsset(sourceURL: URL) -> Observable<AVAsset> {
//        let length = Float(asset.duration.value) / Float(asset.duration.timescale)
//        print("video length: \(length) seconds")
        
        return Observable.just(AVAsset(url: sourceURL))
    }
    
    func trimVideo(sourceURL: URL, startTime: CMTime, endTime: CMTime) -> Observable<URL> {
        
        return Observable.create { [weak self] observer in
            let asset = AVAsset(url: sourceURL as URL)
            
            
            guard let outputURL = self?.outputURL(),
                  let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)  else {
                observer.onError(RxError.unknown)
                return Disposables.create()
            }

            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4

            let timeRange = CMTimeRange(start: startTime, end: endTime)
            
            exportSession.timeRange = timeRange

            exportSession.exportAsynchronously {
                switch exportSession.status {
                case .completed:
                    observer.onNext(outputURL)
                    observer.onCompleted()
                    
                case .failed, .cancelled:
                    observer.onError(RxError.unknown)
                    
                default:
                    observer.onError(RxError.unknown)
                }
            }

            return Disposables.create {
                exportSession.cancelExport()
            }
        }
    }

    // 비디오 저장 임시 디렉토리
    private func outputURL() -> URL? {
        let manager = FileManager.default
        let mediaType = "mp4"
        
        do {
            let documentDirectory = try manager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            var outputURL = documentDirectory.appendingPathComponent("output")
            outputURL = outputURL.appendingPathComponent("\(UUID().uuidString).\(mediaType)")
            try manager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
            try manager.removeItem(at: outputURL)
            return outputURL
        } catch let error {
            print(error)
        }
        
        return nil
    }
}
