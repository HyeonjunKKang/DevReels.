//
//  ReelsCell.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import DRVideoController
import RxSwift
import RxCocoa
import AVFoundation

final class ReelsCell: UITableViewCell, Identifiable {
    // MARK: - Properties
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "릴스 제목"
        $0.textColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.text = "설명"
        $0.textColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "profile")
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var heartImageView = RxUIImageView(frame: .zero).then {
        $0.image = UIImage(named: "heart")
        $0.tintColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var heartNumberLabel = UILabel().then {
        $0.text = "5.0k"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var commentImageView = RxUIImageView(frame: .zero).then {
        $0.image = UIImage(named: "comment")
        $0.tintColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var commentNumberLabel = UILabel().then {
        $0.text = "25"
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.textColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var shareImageView = UIImageView().then {
        $0.image = UIImage(named: "share")
        $0.tintColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 2, height: 2)
        $0.layer.shadowOpacity = 0.5
        $0.layer.shadowRadius = 4
        $0.layer.masksToBounds = false
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private lazy var bottomGradientImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private lazy var githubButton = UIButton().then {
        $0.setTitle(" 지금 영상 속 Github로!", for: .normal)
        $0.setImage(UIImage(named: "github"), for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = .devReelsColor.primary90
        $0.layer.cornerRadius = 24
    }
        
    var reels: Reels?
    var commentButtonTap = PublishSubject<Reels>()
    var heartButtonTap = PublishSubject<Int>()
    let isHeartFilled = BehaviorSubject<Bool>(value: false)
    var disposeBag = DisposeBag()
    var videoLayer = AVPlayerLayer()
    var videoURL: String?
    
    // MARK: - Inits
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.backgroundColor = .devReelsColor.neutral10
        commentImageView.tapEvent
            .subscribe(onNext: { [weak self] in
                self?.commentButtonTap
                    .onNext(self?.reels ?? Reels.Constants.mockReels)
            })
            .disposed(by: disposeBag)
        
        heartImageView.tapEvent
            .subscribe(onNext: { [weak self] in
                self?.heartButtonTap
                    .onNext(Int(self?.heartNumberLabel.text ?? "") ?? 0)
            })
            .disposed(by: disposeBag)
        
        isHeartFilled
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isFilled in
                guard let self = self else { return }
                
                if isFilled {
                    heartImageView.image = UIImage(systemName: "heart.fill")
                } else {
                    heartImageView.image = UIImage(systemName: "heart")
                }
            })
            .disposed(by: disposeBag)
        
        layout()
        self.layoutIfNeeded()
        
        videoLayer.videoGravity = AVLayerVideoGravity.resize
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        thumbnailImageView.imageURL = nil
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureGradient()
        videoLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width - 32, height: thumbnailImageView.frame.height)
        self.thumbnailImageView.layer.cornerRadius = 12
        self.videoLayer.cornerRadius = 12
    }
    
    func configureGradient() {
        let color1 = UIColor.black.withAlphaComponent(0.0)
        let color2 = UIColor.black.withAlphaComponent(0.7)
        let gradient = UIImage.createGradient(color1: color1, color2: color2, frame: bottomGradientImageView.bounds)
        bottomGradientImageView.image = gradient
    }
    
    func configureCell(data: Reels) {
        self.thumbnailImageView.imageURL = data.thumbnailURL
        self.videoURL = data.videoURL
        self.titleLabel.text = data.title
        self.descriptionLabel.text = data.videoDescription
        self.heartNumberLabel.text = "\(data.hearts)"
        self.reels = data
    }
    
    // MARK: - Layout
    private func layout() {
        contentView.addSubViews([thumbnailImageView, bottomGradientImageView, titleLabel, descriptionLabel, heartImageView])
        
        contentView.addSubViews([heartNumberLabel, commentImageView, commentNumberLabel, shareImageView, profileImageView, githubButton])

        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(73)
        }
        
        thumbnailImageView.layer.insertSublayer(videoLayer, at: 0)
        videoLayer.frame = thumbnailImageView.bounds
        videoLayer.videoGravity = .resizeAspectFill
        videoLayer.masksToBounds = true
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top).offset(23)
            $0.leading.equalTo(thumbnailImageView.snp.leading).offset(20)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
        }
        
        shareImageView.snp.makeConstraints {
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-17.5)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            $0.width.height.equalTo(40)
        }
        
        commentNumberLabel.snp.makeConstraints {
            $0.bottom.equalTo(shareImageView.snp.top).offset(-20)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            $0.width.equalTo(40)
            $0.height.equalTo(12)
        }
        
        commentImageView.snp.makeConstraints {
            $0.bottom.equalTo(commentNumberLabel.snp.top)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            $0.width.height.equalTo(40)
        }
        
        heartNumberLabel.snp.makeConstraints {
            $0.bottom.equalTo(commentImageView.snp.top).offset(-20)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            $0.width.equalTo(40)
            $0.height.equalTo(12)
        }
        
        heartImageView.snp.makeConstraints {
            $0.bottom.equalTo(heartNumberLabel.snp.top)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            $0.width.height.equalTo(40)
        }
        
        profileImageView.snp.makeConstraints {
            $0.bottom.equalTo(heartImageView.snp.top).offset(-20)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing).offset(-12)
            $0.width.equalTo(47)
            $0.height.equalTo(60)
        }
        
        githubButton.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).inset(-14)
            $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(10)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        bottomGradientImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(-120)
            $0.leading.equalTo(thumbnailImageView.snp.leading)
            $0.trailing.equalTo(thumbnailImageView.snp.trailing)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom)
        }
    }
}

extension ReelsCell: PlayVideoLayerContainer {
    func visibleVideoHeight() -> CGFloat {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(
            thumbnailImageView.frame,
            from: thumbnailImageView)
        guard let videoFrame = videoFrameInParentSuperView,
              let superViewFrame = superview?.frame else {
                  return 0
              }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size.height
    }
}
