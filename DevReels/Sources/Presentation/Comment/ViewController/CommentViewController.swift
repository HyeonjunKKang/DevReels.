//
//  CommentViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/28.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Then
import RxKeyboard
import FirebaseFirestore

struct ActionSheet {
    let title: String
    let message: String
    let actions: [UIAlertAction]
}

final class CommentViewController: ViewController {
    
    // MARK: - Components
    
    private lazy var tableView = UITableView().then {
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identifier)
        $0.rowHeight = UITableView.automaticDimension
    }
    
    private let commentInputView = CommentInputView(frame: .zero)
    
    private let rightBarButton = UIButton().then {
        $0.setTitle("X", for: .normal)
    }
    
    // MARK: - Properties

    private let viewModel: CommentViewModel
    private let dotdotdotButtonTapped = PublishSubject<Comment>()
    private let profileImageViewTapped = PublishSubject<Comment>()
    
    // MARK: - Inits
    
    init(viewModel: CommentViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
    }
    
    // MARK: - Methods
    
    override func bind() {
        
        let input = CommentViewModel.Input(
            viewWillAppear: rx.viewDidLoad.asObservable(),
            backButtonTapped: rightBarButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            inputButtonDidTap: commentInputView.inputButton.rx.tap.asObservable()
                .throttle(.seconds(1), scheduler: MainScheduler.instance),
            inputViewText: commentInputView.textField.rx.text.orEmpty.asObservable(),
            selectedDotDotDot: dotdotdotButtonTapped
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            selectedUserProfile: profileImageViewTapped
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.presentAlert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
        
        output.deleteAlert
            .emit(to: rx.presentActionSheet)
            .disposed(by: disposeBag)
        
        bindInputView(output: output)
        bindTableView(output: output)
    }
    
    func bindTableView(output: CommentViewModel.Output) {
        
        output.commentList
            .drive(tableView.rx.items(
                cellIdentifier: CommentCell.identifier,
                cellType: CommentCell.self)) { [weak self] _, comment, cell in
                    guard let self = self else { return }
                    cell.prepareForReuse()
                    cell.configureCell(data: comment, reels: output.reels)
                    cell.selectionStyle = .none
                    
                    cell.dotdotdotButtonTap
                        .bind(to: self.dotdotdotButtonTapped)
                        .disposed(by: self.disposeBag)
                    
                    cell.profileImageViewTap
                        .bind(to: self.profileImageViewTapped)
                        .disposed(by: self.disposeBag)
                }
                .disposed(by: disposeBag)
    }
    
    func bindInputView(output: CommentViewModel.Output) {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                self?.commentInputView.snp.updateConstraints {
                    $0.bottom.equalTo(self?.view ?? UIView()).offset(-keyboardHeight)
                }
                self?.view.layoutIfNeeded()
            })
            .disposed(by: disposeBag)
        
        output.commentUploadCompleted
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.commentInputView.textField.text = nil
            })
            .disposed(by: disposeBag)
        
        output.profileImageURL
            .subscribe(onNext: { [weak self] urlString in
                guard let self = self else { return }
                self.commentInputView.userimageView.imageURL = urlString
            })
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(commentInputView)
        
        commentInputView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
    func attribute() {
        navigationItem.title = "댓글"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBarButton)
    }
}
