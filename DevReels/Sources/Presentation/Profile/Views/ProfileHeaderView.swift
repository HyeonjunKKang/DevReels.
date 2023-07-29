//
//  ProfileHeaderView.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/07.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class ProfileHeaderView: UICollectionReusableView, Identifiable {
    
    private enum Metrics {
        
        enum BlogGithubStackView {
            static let blogGithubImageViewWidHeight: CGFloat = 28
            static let spacing: CGFloat = 8
            static let stackViewHeight = 58
        }
        
        enum UserImage {
            static let widthHeight: CGFloat = 100
            static let topMargin = 20.5
        }

        enum UserNameLabel {
            static let topMargin = 18
            static let height: CGFloat = 26
        }
        
        enum IntroduceLabel {
            static let topMargin = 4
            static let height: CGFloat = 22
        }
        
        enum CountStackView {
            static let topMargin = 18
            static let spacing: CGFloat = 14
            static let eachSpacing: CGFloat = 4
        }
        
        enum FollowingButton {
            static let topMargin = 42.5
            static let corneradius: CGFloat = 8
        }
    }
    
    // MARK: - Properties
    
    private let blogImageView = UIImageView().then {
        $0.image = UIImage(named: "profileBlog")
    }
    
    private let githubImageView = UIImageView().then {
        $0.image = UIImage(named: "profileGithub")
        $0.backgroundColor = .gray
    }
    
    private let userImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = .gray
        $0.image = UIImage(systemName: "person")
    }
    
    private let userNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(
            ofSize: 20,
            weight: .bold
        )
    }
    
    private let introduceLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = .systemFont(
            ofSize: 14,
            weight: .semibold
        )
    }
    
    private let postLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.text = "게시물"
        $0.textColor = .devReelsColor.neutral400
    }
    
    private let postCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "100"
        $0.textColor = .white
    }
    
    private let followerLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.text = "팔로워"
        $0.textColor = .devReelsColor.neutral400
    }
    
    private let followerCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "100"
        $0.textColor = .white
    }
    
    private let followingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.text = "팔로잉"
        $0.textColor = .devReelsColor.neutral400
    }
    
    private let followingCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.text = "100"
        $0.textColor = .white
    }
    
    private lazy var postCountStackView = UIStackView(arrangedSubviews: [postLabel, postCountLabel]).then {
        $0.axis = .horizontal
        $0.spacing = Metrics.CountStackView.eachSpacing
    }
    
    private lazy var followerCountStackView = UIStackView(arrangedSubviews: [followerLabel, followerCountLabel]).then {
        $0.axis = .horizontal
        $0.spacing = Metrics.CountStackView.eachSpacing
    }
    
    private lazy var followingCountStackView = UIStackView(arrangedSubviews: [followingLabel, followingCountLabel]).then {
        $0.axis = .horizontal
        $0.spacing = Metrics.CountStackView.eachSpacing
    }
    
    private let followButton = UIButton().then {
        $0.layer.cornerRadius = Metrics.FollowingButton.corneradius
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.backgroundColor = .devReelsColor.primary90
        $0.setTitle("< Follow >", for: .normal)
    }
    
    private let unfollowButton = UIButton().then {
        $0.layer.cornerRadius = Metrics.FollowingButton.corneradius
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.backgroundColor = .devReelsColor.neutral40
        $0.setTitle("< UnFollow >", for: .normal)
    }
    
    private let editButton = UIButton().then {
        $0.layer.cornerRadius = Metrics.FollowingButton.corneradius
        $0.clipsToBounds = true
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitle("< Edit >", for: .normal)
        $0.setBackgroundColor(UIColor.devReelsColor.neutral40 ?? UIColor.darkGray, for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private let settingButton = UIButton().then {
        $0.layer.cornerRadius = Metrics.FollowingButton.corneradius
        $0.clipsToBounds = true
        $0.titleLabel?.font = .systemFont(ofSize: 16)
        $0.setTitle("< Setting >", for: .normal)
        $0.setBackgroundColor(UIColor.devReelsColor.neutral40 ?? UIColor.darkGray, for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }
    
    private lazy var editAndSettingButtonStackView = UIStackView(arrangedSubviews: [editButton, settingButton]).then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    private var blogImageViewTapSubject = PublishSubject<Void>()
    private var githubImageViewTapSubject = PublishSubject<Void>()
    
    var blogImageViewTap: Observable<Void> {
        return blogImageViewTapSubject.asObservable()
    }
    
    var githubImageViewTap: Observable<Void> {
        return githubImageViewTapSubject.asObservable()
    }
    
    var editButtonTap: Observable<Void> {
        return editButton.rx.tap.asObservable()
    }
    
    var settingButtonTap: Observable<Void> {
        return settingButton.rx.tap.asObservable()
    }
    
    var followButtonTap: Observable<Void> {
        return followButton.rx.tap.asObservable()
    }
    
    var unfollowButtonTap: Observable<Void> {
        return unfollowButton.rx.tap.asObservable()
    }
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layout()
        
        let blogTapGesture = UITapGestureRecognizer(target: self, action: #selector(blogImageViewTapped))
        blogImageView.addGestureRecognizer(blogTapGesture)
        blogImageView.isUserInteractionEnabled = true
        
        let githubTapGesture = UITapGestureRecognizer(target: self, action: #selector(githubImageViewTapped))
        githubImageView.addGestureRecognizer(githubTapGesture)
        githubImageView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    func configure(header: Header) {
        self.userImageView.imageURL = header.profileImageURLString
        self.userNameLabel.text = header.userName
        
        let text = NSMutableAttributedString(string: header.introduce)
        text.addAttribute(.foregroundColor, value: UIColor.devReelsColor.primary90, range: NSRange(location: 0, length: 1))
        text.addAttribute(.foregroundColor, value: UIColor.devReelsColor.primary90, range: NSRange(location: header.introduce.count - 2, length: 2))
        
        self.introduceLabel.attributedText = text
        
        self.postCountLabel.text = header.postCount
        
        self.followerCountLabel.text = header.followerCount
        self.followingCountLabel.text = header.followingCount
        
        self.followButton.isHidden = header.isMyProfile
        self.followButton.isUserInteractionEnabled = !header.isMyProfile
        
        self.unfollowButton.isHidden = header.isMyProfile
        self.unfollowButton.isUserInteractionEnabled = !header.isMyProfile
        
        switch header.buttonType {
        case .following:
            followButton.isHidden = true
        default:
            break
        }
        
//        settingButton.rx.tap.subscribe(onNext: { _ in print("taptaptapatpatap")})
    }
    
    func layout() {
        var linkStackView = UIStackView(arrangedSubviews: [blogImageView, githubImageView]).then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.spacing = Metrics.BlogGithubStackView.spacing
        }
    
        addSubview(linkStackView)
        
        linkStackView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(Metrics.BlogGithubStackView.stackViewHeight)
        }
        
        blogImageView.snp.makeConstraints {
            $0.height.width.equalTo(Metrics.BlogGithubStackView.blogGithubImageViewWidHeight)
        }
        
        githubImageView.snp.makeConstraints {
            $0.height.width.equalTo(Metrics.BlogGithubStackView.blogGithubImageViewWidHeight)
        }
        
        addSubview(userImageView)
        
        userImageView.snp.makeConstraints {
            $0.top.equalTo(linkStackView.snp.bottom).offset(Metrics.UserImage.topMargin)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(Metrics.UserImage.widthHeight)
        }
        
        addSubview(userNameLabel)
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(Metrics.UserNameLabel.topMargin)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Metrics.UserNameLabel.height)
        }
        
        addSubview(introduceLabel)
        
        introduceLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(Metrics.IntroduceLabel.topMargin)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(Metrics.IntroduceLabel.height)
        }
        
        let countStackView = UIStackView(arrangedSubviews: [postCountStackView, followerCountStackView, followingCountStackView]).then {
            $0.axis = .horizontal
            $0.spacing = Metrics.BlogGithubStackView.spacing
        }
        
        addSubview(countStackView)
        
        countStackView.snp.makeConstraints {
            $0.top.equalTo(introduceLabel.snp.bottom).offset(Metrics.CountStackView.topMargin)
            $0.centerX.equalToSuperview()
        }
        
        addSubview(editAndSettingButtonStackView)
        
        editAndSettingButtonStackView.snp.makeConstraints {
            $0.top.equalTo(countStackView.snp.bottom).offset(Metrics.FollowingButton.topMargin)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addSubview(unfollowButton)
        
        unfollowButton.snp.makeConstraints {
            $0.top.equalTo(countStackView.snp.bottom).offset(Metrics.FollowingButton.topMargin)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        addSubview(followButton)
        
        followButton.snp.makeConstraints {
            $0.top.equalTo(countStackView.snp.bottom).offset(Metrics.FollowingButton.topMargin)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        [blogImageView, githubImageView].forEach {
            $0.layer.cornerRadius = Metrics.BlogGithubStackView.blogGithubImageViewWidHeight / 2
            $0.clipsToBounds = true
        }
        
        userImageView.layer.cornerRadius = Metrics.UserImage.widthHeight / 2
        userImageView.clipsToBounds = true
    }
    
    @objc private func blogImageViewTapped() {
        blogImageViewTapSubject.onNext(())
    }
    
    @objc private func githubImageViewTapped() {
        githubImageViewTapSubject.onNext(())
    }
}
