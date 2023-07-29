//
//  ProfileViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

struct Header {
    var profileImageURLString: String
    var userName: String
    var introduce: String
    var githubURL: String
    var blogURL: String
    var postCount: String
    var followerCount: String
    var followingCount: String
    var isMyProfile: Bool
    var buttonType: ButtonEnableType
}

struct SectionOfReelsPost {
    var header: Header
    var items: [Item]
}

extension SectionOfReelsPost: SectionModelType {
    typealias Item = Reels
    
    init(original: SectionOfReelsPost, items: [Reels]) {
        self = original
        self.items = items
    }
}

final class ProfileViewController: ViewController {
    
    // MARK: - Constants
    private enum Metric {
        enum PostCollectionView {
            static let leftMargin = 0
            static let topMargin = 0
            static let rightMargin = 0
            static let bottomMargin = 0
        }
    }
    
    private enum Constant {
        static let headerTitle: String = "마이페이지"
    }

    // MARK: - Components
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = CGFloat(12)
        layout.minimumInteritemSpacing = CGFloat(12)
        
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )

        collectionView.register(ReelsCollectionCell.self, forCellWithReuseIdentifier: ReelsCollectionCell.identifier)
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeaderView.identifier)
                                
        collectionView.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 0, right: 20)
        return collectionView
    }()
    
    private let doneButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = .white
    }
    
    // MARK: - Propertie
    
    var viewModel: ProfileViewModel
    private let blogImageViewTapSubject = PublishSubject<Void>()
    private let githubImageViewTapSubject = PublishSubject<Void>()
    private let followButtonTapSubject = PublishSubject<Void>()
    private let unfollowButtonTapSubject = PublishSubject<Void>()
    private let editButtonTapSubject = PublishSubject<Void>()
    private let settingButtonTapSubject = PublishSubject<Void>()
    
    // MARK: - DataSource
    
    private lazy var  dataSource = RxCollectionViewSectionedReloadDataSource<SectionOfReelsPost>(
        configureCell: { (dataSource, collectionView, indexPath, item) in
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ReelsCollectionCell.identifier,
            for: indexPath
        ) as? ReelsCollectionCell else { return UICollectionViewCell() }

            cell.bind(reels: item)
            
        return cell
    }, configureSupplementaryView: { [weak self] dataSource, collectionView, _, indexPath in
       
        guard let self = self,
              let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ProfileHeaderView.identifier,
            for: indexPath
        ) as? ProfileHeaderView else { return UICollectionReusableView() }
        
        header.configure(header: dataSource.sectionModels[indexPath.section].header)
        header.blogImageViewTap
            .bind(to: self.blogImageViewTapSubject)
            .disposed(by: disposeBag)
        
        header.githubImageViewTap
            .bind(to: self.githubImageViewTapSubject)
            .disposed(by: disposeBag)
        
        header.followButtonTap
            .bind(to: self.followButtonTapSubject)
            .disposed(by: disposeBag)
        
        header.editButtonTap
            .bind(to: self.editButtonTapSubject)
            .disposed(by: disposeBag)
        
        header.settingButtonTap
            .bind(to: self.settingButtonTapSubject)
            .disposed(by: disposeBag)
        
        header.unfollowButtonTap
            .bind(to: self.unfollowButtonTapSubject)
            .disposed(by: disposeBag)
        
        return header
    })
    
    // MARK: - inits
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        layout()
        self.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: Bind View Model
    override func bind() {
        
        let input = ProfileViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () }.asObservable(),
            viewDidLoad: rx.viewDidLoad.map { _ in () }.asObservable(),
            blogImageViewTap: blogImageViewTapSubject,
            githubImageViewTap: githubImageViewTapSubject,
            followButtonTap: followButtonTapSubject,
            unfollowBUttonTap: unfollowButtonTapSubject,
            editButtonTap: editButtonTapSubject,
            settingButtonTap: settingButtonTapSubject
                .throttle(.seconds(1), latest: false, scheduler: MainScheduler.asyncInstance),
            backButtonTap: doneButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            )
        
        let output = viewModel.transform(input: input)
        
        // bindCollectionView
        output.collectionViewDataSource
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.isMyprofile
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.navigationController?.isNavigationBarHidden = true
                    self?.navigationItem.leftBarButtonItem = nil
                } else {
                    self?.navigationController?.isNavigationBarHidden = false
                    self?.navigationItem.hidesBackButton = true
                    self?.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self?.doneButton ?? UIView())
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Layout
    override func layout() {
        
        attribute()
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func attribute() {
//        navigationController?.isNavigationBarHidden = false
//        navigationItem.hidesBackButton = true
//        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: doneButton)
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (UIScreen.main.bounds.width - 12 - 40) / 2.0
        let itemHeight = itemWidth * 1.65
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 380)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
    }
}
