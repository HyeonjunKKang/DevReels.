////
////  ProfileHeaderViewController.swift
////  DevReels
////
////  Created by 강현준 on 2023/06/14.
////  Copyright © 2023 DevReels. All rights reserved.
////
//
// MARK: - 삭제필요
//import UIKit
//import SnapKit
//import Then
//
//protocol ProfileHeaderViewControllable: UIViewController {
//
//}
//
//final class ProfileHeaderViewController: ViewController {
//
//    private enum Metrics {
//
//        enum BlogGithubStackView {
//            static let blogGithubImageViewWidHeight = 28
//            static let spacing: CGFloat = 8
//        }
//
//
//        enum UserImage {
//            static let height = 100
//            static let topMargin = 38
//        }
//
//        enum UserName {
//            static let topMargin = 18
//        }
//
//        enum UserIntroduction {
//            static let topMargin = 4
//        }
//
//        enum PostLabel {
//            static let rightMargin = 14
//        }
//
//        enum FollowerLabel {
//            static let topMargin = 18
//        }
//
//        enum FollowingLabel {
//            static let leftMargin = 14
//        }
//
//        enum FollowerButton {
//            static let horizontalMargin = 16
//            static let topMargin = 37
//            static let height = 37
//        }
//    }
//
//    private let blogImageView = UIImageView().then {
//        $0.backgroundColor = .gray
//    }
//
//    private let githubImageView = UIImageView().then {
//        $0.backgroundColor = .gray
//    }
//
//    private let userImageView = UIImageView().then {
//        $0.clipsToBounds = true
//        $0.contentMode = .scaleAspectFill
//        $0.backgroundColor = .gray
//    }
//
//    private let userNameLabel = UILabel().then {
//        $0.font = .systemFont(
//            ofSize: 20,
//            weight: .bold
//        )
//        $0.text = "김코드"
//    }
//
//    private let userIntroduction = UILabel().then {
//        $0.font = .systemFont(
//            ofSize: 14,
//            weight: .semibold
//        )
//        $0.text = "< 안녕하세요🔥 성장하는 개발자입니다👩‍💻 />"
//    }
//
////    private let postCountLabel = NumberInformationLabel(title: "게시물", count: 100)
//
////    private let followerCountLabel = NumberInformationLabel(title: "팔로워", count: 100)
//
////    private let followingCountLabel = NumberInformationLabel(title: "팔로잉", count: 100)
//
////    private let followerButton: UIButton = {
////        let button = UIButton()
////        button.setTitle("< Follow >", for: .normal)
////        button.titleLabel?.font = .systemFont(ofSize: 16)
////        button.backgroundColor = .init(red: 244, green: 113, blue: 0, alpha: 1)
////        button.layer.cornerRadius = 6
////        return button
////    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        layout()
//    }
//
//    // MARK: - Layout
//    override func layout() {
//
////        var linkStackView = UIStackView(arrangedSubviews: [blogImageView, githubImageView])
////        linkStackView.axis = .horizontal
////        linkStackView.alignment = .center
////        linkStackView.distribution = .fillEqually
////        linkStackView.spacing = Metrics.BlogGithubStackView.spacing
////
////        view.addSubview(linkStackView)
////
////        linkStackView.snp.makeConstraints {
////            $0.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
////            $0.height.equalTo(58)
////        }
//
//        view.addSubViews([blogImageView, githubImageView])
//
//        blogImageView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        [blogImageView, githubImageView].forEach {
//            $0.snp.makeConstraints {
//                $0.height.width.equalTo(Metrics.BlogGithubStackView.blogGithubImageViewWidHeight)
//            }
//        }
//    }
//}
//
//extension ProfileHeaderViewController {
////    func makeStackView(_ views: [UIView], axis: NSLayoutConstraint.Axis, alignment: ) -> UIStackView {
////        let stackView = UIStackView(arrangedSubviews: views)
////        stackView.axis = axis
////        stackView.alignment = .
////    }
//}
