//
//  CommentCell.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class CommentCell: UITableViewCell, Identifiable {
    
    private let profileImageView = RxUIImageView(frame: .zero).then {
        $0.image = UIImage(systemName: "person")
        $0.backgroundColor = .white
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
    }
    
    private let timeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.text = "3시간 전"
    }
    
    private let writer = UILabel().then {
        $0.font = .systemFont(ofSize: 12)
        $0.textColor = .white
        $0.text = "작성자"
        $0.backgroundColor = .devReelsColor.primary80
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.textAlignment = .center
    }
    
    private let dotdotdot = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.tintColor = .devReelsColor.grayscale50
    }
    
     let textView = UITextView().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .devReelsColor.grayscale50
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.textContainerInset = .init(top: 0, left: 0, bottom: 45, right: 0)
    }
    
//    let likenumberLabel = UILabel().then {
//        $0.text = "123"
//        $0.font = .systemFont(ofSize: 13)
//        $0.textColor = .white
//    }
//    
//    private let likeImageView = RxUIImageView(frame: .zero).then {
//        $0.tintColor = .white
//        $0.image = UIImage(systemName: "heart")
//    }
    
    private let disposeBag = DisposeBag()
    private var dotdotdotButtonTapSubject = PublishSubject<Comment>()
    private var profileImageViewTapSubject = PublishSubject<Comment>()
    
    var dotdotdotButtonTap: Observable<Comment> {
        return dotdotdotButtonTapSubject.asObservable()
    }
    
    var profileImageViewTap: Observable<Comment> {
        return profileImageViewTapSubject.asObservable()
    }
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
    }
    

    func configureCell(data: Comment, reels: Reels?) {
        self.nameLabel.text = data.writerNickName
        self.textView.text = data.content
//        self.likenumberLabel.text = data.likes.toString
        self.timeLabel.text = data.date.toDateString()

        guard let url = URL(string: data.writerProfileImageURL) else { return }
        
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .map { data -> UIImage in
                return UIImage(data: data.data) ?? UIImage()
            }
            .bind(to: profileImageView.rx.image)
            .disposed(by: disposeBag)
        
        if data.writerUID != reels?.uid {
            writer.isHidden = true
        }
        
        dotdotdot.rx.tap
            .map { data }
            .subscribe(onNext: { [weak self] in
                self?.dotdotdotButtonTapSubject.onNext($0)
            })
            .disposed(by: disposeBag)
        
        profileImageView.tapEvent
            .map { data }
            .subscribe(onNext: {[weak self] in
                self?.profileImageViewTapSubject.onNext($0)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    func layout() {
        contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints {
            $0.height.width.equalTo(32)
            $0.leading.top.equalToSuperview().offset(16)
        }
        
        contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(12)
        }
        
        contentView.addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(nameLabel.snp.trailing).offset(8)
        }
        
        contentView.addSubview(writer)
        
        writer.snp.makeConstraints {
            $0.centerY.equalTo(timeLabel)
            $0.leading.equalTo(timeLabel.snp.trailing).offset(4)
            $0.width.equalTo(44)
            $0.height.equalTo(18)
        }
        
        contentView.addSubview(dotdotdot)
        
        dotdotdot.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17.5)
            $0.centerY.equalTo(timeLabel)
            $0.width.height.equalTo(18)
        }
        
        contentView.addSubview(textView)
        
        textView.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalTo(dotdotdot.snp.trailing)
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.bottom.equalToSuperview()
        }

//        contentView.addSubview(likenumberLabel)
//
//        likenumberLabel.snp.makeConstraints {
//            $0.trailing.equalTo(dotdotdot.snp.trailing)
//            $0.bottom.equalToSuperview().inset(17)
//        }
//
//        contentView.addSubview(likeImageView)
//
//        likeImageView.snp.makeConstraints {
//            $0.trailing.equalTo(likenumberLabel.snp.leading).inset(-3)
//            $0.height.width.equalTo(14)
//            $0.bottom.equalTo(likenumberLabel)
//        }
    }
}
