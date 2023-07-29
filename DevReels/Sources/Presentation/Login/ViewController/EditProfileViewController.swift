//
//  EditProfileViewController.swift
//  DevReels
//
//  Created by HoJun on 2023/07/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import SnapKit

final class EditProfileViewController: ViewController {
    
    // MARK: - Properties
        
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = true
    }
    
    private let contentView = UIView()
    
    private let roundProfileImageView = RoundProfileImageView(120.0)
    
    private let addImageButton = UIButton()
    
    private let nameTextfield = TextField().then {
        $0.title = "이름"
        $0.maxCount = 15
        $0.placeholder = "이름을 입력해주세요."
    }
    
    private let introduceCountTextView = CountTextView().then {
        $0.title = "소개문구"
        $0.maxCount = 50
        $0.placeholder = "자신을 소개해주세요."
    }
    
    private lazy var githubToggleTextField = ToggleUrlTextfield().then {
        $0.toggleBarImage = UIImage(systemName: "square.and.arrow.up")
        $0.toggleBarTitle = "나의 Github 링크 추가하기"
        $0.textFieldTitle = "링크"
        $0.placeholder = "Github 링크를 입력해주세요"
        $0.scrollview = self.scrollView
    }
    
    private lazy var blogToggleTextField = ToggleUrlTextfield().then {
        $0.toggleBarImage = UIImage(systemName: "square.and.arrow.up")
        $0.toggleBarTitle = "나의 블로그 링크 추가하기"
        $0.textFieldTitle = "링크"
        $0.placeholder = "블로그 링크를 입력해주세요"
        $0.scrollview = self.scrollView
    }
    
    private let completeButton = ValidationButton().then {
        $0.isEnabled = false
        $0.setTitle("완료", for: .normal)
    }
    
    private var viewModel: EditProfileViewModel
    private var imagePicker: UIImagePickerController?
    private let selectedProfileImage = PublishRelay<UIImage>()
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureImagePicker()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Binds
    
    override func bind() {
        
        let input = EditProfileViewModel.Input(
            name: nameTextfield.rx.text.orEmpty.asObservable(),
            introduce: introduceCountTextView.rx.text.orEmpty.asObservable(),
            profileImage: selectedProfileImage.asObservable(),
            urlValidation: Observable.combineLatest(githubToggleTextField.rx.validSubmit,
                                                    blogToggleTextField.rx.validSubmit).map { $0 && $1 },
            githubUrlString: githubToggleTextField.rx.urlString.orEmpty.asObservable(),
            blogUrlString: blogToggleTextField.rx.urlString.orEmpty.asObservable(),
            completeButtonTapped: completeButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            backButtonTapped: backButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardVisibleHeight in
                self?.scrollView.contentInset.bottom = keyboardVisibleHeight
            })
            .disposed(by: disposeBag)
        
        addImageButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { viewController, _ in
                viewController.presentImagePicker()
            })
            .disposed(by: disposeBag)

        let output = viewModel.transform(input: input)
        
        output.type
            .drive(onNext: { [weak self] in
                switch $0 {
                case .create:
                    self?.backButton.isHidden = true
                    self?.navigationItem.title = "프로필 생성"
                case .edit:
                    self?.backButton.isHidden = false
                    self?.navigationItem.title = "프로필 수정"
                }
            })
            .disposed(by: disposeBag)
        
        output.originName
            .drive(nameTextfield.rx.text)
            .disposed(by: disposeBag)

        output.originIntroduce
            .drive(introduceCountTextView.rx.text)
            .disposed(by: disposeBag)

        output.originProfileImage
            .map { $0 ?? UIImage(systemName: "person.crop.circle")?
                .withTintColor(.devReelsColor.neutral200 ?? .white, renderingMode: .alwaysOriginal) }
            .drive(roundProfileImageView.rx.image)
            .disposed(by: disposeBag)

        output.inputValidation
            .drive(completeButton.rx.isEnabled)
            .disposed(by: disposeBag)

    }

    // MARK: - Methods

    override func layout() {
        
        view.addSubview(completeButton)
        completeButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(49)
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(completeButton.snp.top)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        contentView.addSubview(roundProfileImageView)
        roundProfileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(24.0)
        }
        
        contentView.addSubview(addImageButton)
        addImageButton.snp.makeConstraints { make in
            make.edges.equalTo(roundProfileImageView)
        }
        
        contentView.addSubview(nameTextfield)
        nameTextfield.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(roundProfileImageView.snp.bottom).offset(28)
        }
        
        contentView.addSubview(introduceCountTextView)
        introduceCountTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(nameTextfield.snp.bottom).offset(18)
            make.height.equalTo(123)
        }
        
        contentView.addSubview(githubToggleTextField)
        githubToggleTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16.0)
            make.top.equalTo(introduceCountTextView.snp.bottom).offset(18)
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
    
    private func configureNavigationBar() {
        navigationItem.title = "프로필 생성"
    }
}

// MARK: Picker

private extension EditProfileViewController {
    func configureImagePicker() {
        imagePicker = UIImagePickerController()
        imagePicker?.allowsEditing = true
        imagePicker?.delegate = self
    }
    
    func presentImagePicker() {
        guard let imagePicker = imagePicker else { return }
        present(imagePicker, animated: true)
    }
}

// MARK: Picker Delegate

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        var newImage: UIImage?
        
        if let possibleImage = info[.editedImage] as? UIImage { // 수정된 이미지가 있을 경우
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage { // 오리지널 이미지가 있을 경우
            newImage = possibleImage
        }
        
        if let image = newImage {
            selectedProfileImage.accept(image)
        }
        
        picker.dismiss(animated: true)
    }
}
