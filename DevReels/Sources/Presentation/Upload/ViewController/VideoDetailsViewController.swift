//
//  VideoDetailsViewController.swift
//  DevReels
//
//  Created by HoJun on 2023/05/25.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard
import Then

final class VideoDetailsViewController: ViewController {
    
    // MARK: - Properties
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = true
    }
    
    private let contentView = UIView()
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .black
    }
    
    private let titleTextField = TextField().then {
        $0.placeholder = "제목을 입력하세요"
        $0.title = "제목"
    }
    
    private let descriptionTextView = CountTextView().then {
        $0.placeholder = "내용을 입력하세요"
        $0.title = "내용"
        $0.maxCount = 100
    }
    
    private lazy var githubToggleTextField = ToggleUrlTextfield().then {
        $0.toggleBarImage = UIImage(systemName: "square.and.arrow.up")
        $0.toggleBarTitle = "Github 링크 추가하기"
        $0.textFieldTitle = "링크"
        $0.placeholder = "Github 링크를 입력해주세요"
        $0.scrollview = self.scrollView
    }
    
    private lazy var blogToggleTextField = ToggleUrlTextfield().then {
        $0.toggleBarImage = UIImage(systemName: "square.and.arrow.up")
        $0.toggleBarTitle = "블로그 링크 추가하기"
        $0.textFieldTitle = "링크"
        $0.placeholder = "블로그 링크를 입력해주세요"
        $0.scrollview = self.scrollView
    }
    
    private let uploadButton = ValidationButton().then {
        $0.isEnabled = false
        $0.setTitle("< Upload >", for: .normal)
    }
    
    private var viewModel: VideoDetailsViewModel
    
    init(viewModel: VideoDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - binds
    
    override func bind() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
        
        let urlValidation = Observable.combineLatest(githubToggleTextField.rx.validSubmit,
                                        blogToggleTextField.rx.validSubmit)
            .map { $0 && $1 }
        
        let githubUrlString = githubToggleTextField.rx.validSubmit
            .flatMap { isValid in
                isValid ? self.githubToggleTextField.rx.urlString.orEmpty.asObservable() : Observable.just("")
            }
        
        let blogUrlString = blogToggleTextField.rx.validSubmit
            .flatMap { isValid in
                isValid ? self.blogToggleTextField.rx.urlString.orEmpty.asObservable() : Observable.just("")
            }
            
        let input = VideoDetailsViewModel.Input(
            backButtonTapped: backButton.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance),
            title: titleTextField.rx.text.orEmpty.asObservable(),
            description: descriptionTextView.rx.text.orEmpty.asObservable(),
            urlValidation: Observable.combineLatest(githubToggleTextField.rx.validSubmit,
                                                    blogToggleTextField.rx.validSubmit).map { $0 && $1 },
            githubUrlString: githubToggleTextField.rx.urlString.orEmpty.asObservable(),
            blogUrlString: blogToggleTextField.rx.urlString.orEmpty.asObservable(),
            uploadButtonTapped: uploadButton.rx.tap.asObservable()
            )
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
            
        let output = viewModel.transform(input: input)
        
        output.uploadButtonEnabled
            .drive(uploadButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        thumbnailImageView.image = output.thumbnailImage
    }
    
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.title = "세부정보 입력하기"
    }
    
    override func layout() {
        
        view.addSubview(uploadButton)
        uploadButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(49)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(uploadButton.snp.top)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(20)
        }
        
        contentView.addSubview(titleTextField)
        titleTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(thumbnailImageView.snp.bottom).offset(18)
        }
        
        contentView.addSubview(descriptionTextView)
        descriptionTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(titleTextField.snp.bottom).offset(18)
            make.height.equalTo(150)
        }
        
        contentView.addSubview(githubToggleTextField)
        githubToggleTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(18)
        }
        
        contentView.addSubview(blogToggleTextField)
        blogToggleTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(githubToggleTextField.snp.bottom).offset(18)
        }
    
        let marginView = UIView()
        contentView.addSubview(marginView)
        marginView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(30)
            $0.top.equalTo(blogToggleTextField.snp.bottom)
        }
    }
}
