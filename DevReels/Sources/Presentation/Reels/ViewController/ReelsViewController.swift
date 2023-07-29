//
//  ReelsViewController.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import DRVideoController
import AVFoundation

final class ReelsViewController: UIViewController {
    
    // MARK: - Properties
    private lazy var tableView = UITableView().then {
        $0.register(ReelsCell.self, forCellReuseIdentifier: ReelsCell.identifier)
        $0.rowHeight = UIScreen.main.bounds.height
        $0.backgroundColor = .systemBackground
        $0.showsVerticalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.bounces = false
        $0.showsVerticalScrollIndicator = false
        $0.contentInsetAdjustmentBehavior = .never
    }
    
    private lazy var topGradientImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var playImageView = UIImageView().then {
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.image = UIImage(systemName: "play.circle.fill")
        $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .systemGray5
        $0.alpha = 0
    }
    
    private lazy var pauseImageView = UIImageView().then {
        $0.adjustsImageSizeForAccessibilityContentSizeCategory = true
        $0.image = UIImage(systemName: "pause.circle.fill")
        $0.image = $0.image?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .systemGray5
        $0.alpha = 0
    }
    
    var commentButtonTapped = PublishSubject<Reels>()
    var heartButtonTapped = PublishSubject<Int>()
    
    private let viewModel: ReelsViewModel
    private var videoController: VideoPlayerController {
        viewModel.videoController
    }
    private let disposeBag = DisposeBag()
    private var currentReels: Reels?
    
    // MARK: - Inits
    init(viewModel: ReelsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        bind()
    }
    
    func bind() {
        let input = ReelsViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            viewWillDisAppear: rx.viewWillDisappear.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            viewDidAppear: rx.viewDidAppear.map { _ in }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            reelsTapped: tableView.rx.itemSelected.map { _ in () }
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            reelsWillDisplay: tableView.rx.willDisplayCell.map { $0.indexPath },
            reelsEndDisplay: tableView.rx.didEndDisplayingCell.map { $0.indexPath },
            reelsWillBeginDragging: tableView.rx.willBeginDragging.map { _ in },
            reelsDidEndDragging: tableView.rx.didEndDragging.map { _ in },
            commentButtonTap: commentButtonTapped,
            heartButtonTap: heartButtonTapped
        )
        let output = viewModel.transform(input: input)
        
        output.reelsList
            .drive(tableView.rx.items(
                cellIdentifier: ReelsCell.identifier,
                cellType: ReelsCell.self
            )) { [weak self] _, reels, cell in
                guard let self = self else { return }
                
                cell.commentButtonTap
                    .subscribe(onNext: {
                        self.commentButtonTapped.onNext($0)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.heartButtonTap
                    .subscribe(onNext: {
                        self.heartButtonTapped.onNext($0)
                    })
                    .disposed(by: cell.disposeBag)
                
                cell.isHeartFilled
                    .bind(to: viewModel.isHeartFilled)
                    .disposed(by: cell.disposeBag)
                
                viewModel.currentReels.onNext(reels)
                
                cell.prepareForReuse()
                cell.configureCell(data: reels)
                
                guard let url = reels.videoURL else { return }
                
                videoController.setupVideoFor(url: url)
                videoController.playVideo(withLayer: cell.videoLayer, url: url)
            }
            .disposed(by: disposeBag)
        
        output.shouldPlay
            .drive(onNext: { [weak self] isPlay in
                guard let self = self else { return }
                
                if isPlay {
                    playAnimation()
                } else {
                    pauseAnimation()
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDisplayingCell
            .subscribe(onNext: { [weak self] cell, _ in
                guard let self = self else { return }
                
                if let videoCell = cell as? PlayVideoLayerContainer {
                    if videoCell.videoURL != nil {
                        videoController.removeLayerFor(cell: videoCell)
                    }
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDecelerating
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                videoController.pausePlayeVideosFor(tableView: tableView)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDragging
            .subscribe(onNext: { [weak self] decelerate in
                guard let self = self else { return }
                if !decelerate {
                    videoController.pausePlayeVideosFor(tableView: tableView)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func playAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.playImageView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 1.0) {
                self.playImageView.alpha = 0
            }
        })
    }
    
    private func pauseAnimation() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pauseImageView.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 1.0) {
                self.pauseImageView.alpha = 0
            }
        })
    }
    
    // MARK: - Layout
    func layout() {
        view.addSubViews([tableView, topGradientImageView, playImageView, pauseImageView])
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        topGradientImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        playImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
        
        pauseImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
}
