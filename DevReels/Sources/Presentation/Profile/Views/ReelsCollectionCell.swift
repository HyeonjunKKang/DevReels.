//
//  ReelsCollectionCell.swift
//  DevReels
//
//  Created by 강현준 2023/06/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class ReelsCollectionCell: UICollectionViewCell, Identifiable {
    
    // MARK: - Constants
    private enum Metrics {
        enum ThumbnailImageView {
            static let height = 245
            static let cornerRadius: CGFloat = 8
        }
        
        enum Title {
            static let leadingMargin = 8
            static let bottomMargin = 11
        }
        
        enum Like {
            static let topMargin = 6
            static let imageViewLeadingMargin = 8
            static let countLabelLeadingMargin = 2
        }
        
        enum Comment {
            static let imageViewLeadingMargin = 8
            static let countLabelLeadingMargin = 2
        }
    }
    
    // MARK: - Components
    
    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = Metrics.ThumbnailImageView.cornerRadius
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .black
        $0.text = "UI 낙엽 애니메이션 구현하기"
    }
    
    private let likeImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart")
        $0.tintColor = .devReelsColor.neutral60
    }
    
    private let likeCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.text = ""
    }
    
    private let commentImageView = UIImageView().then {
        $0.image = UIImage(systemName: "bubble.right")
        $0.tintColor = .devReelsColor.neutral60
    }
    
    private let commentCountLabel = UILabel().then {
         $0.font = .systemFont(ofSize: 12)
         $0.textColor = .white
         $0.text = ""
     }
    
    // MARK: - Properties
    
    var viewModel = DIContainer.shared.container.resolve(ProfileCellViewModel.self)
    var disposeBag = DisposeBag()
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func bind(reels: Reels) {
        self.thumbnailImageView.imageURL = reels.thumbnailURL
        self.likeCountLabel.text = "\(reels.hearts)"
        self.titleLabel.text = "\(reels.title)"
        
        let output = viewModel?.transform(input: ProfileCellViewModel.Input(reels: Observable.just(reels)))
        
        output?.commentCount
            .drive(commentCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    private func layout() {
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(Metrics.ThumbnailImageView.height)
        }
        
        thumbnailImageView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Metrics.Title.leadingMargin)
            $0.bottom.equalToSuperview().inset(Metrics.Title.bottomMargin)
        }
        
        contentView.addSubview(likeImageView)
        
        likeImageView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(Metrics.Like.topMargin)
            $0.leading.equalToSuperview().offset(Metrics.Like.imageViewLeadingMargin)
        }
        
        contentView.addSubview(likeCountLabel)
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView)
            $0.leading.equalTo(likeImageView.snp.trailing).offset(Metrics.Like.countLabelLeadingMargin)
        }
        
        contentView.addSubview(commentImageView)
        
        commentImageView.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(Metrics.Comment.imageViewLeadingMargin)
        }
        
        contentView.addSubview(commentCountLabel)
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeImageView)
            $0.leading.equalTo(commentImageView.snp.trailing).offset(Metrics.Comment.countLabelLeadingMargin)
        }
    }
}
