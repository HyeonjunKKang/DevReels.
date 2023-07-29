//
//  SettingViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

final class SettingViewController: ViewController {
    
    // MARK: - Components
    
    private lazy var tableView = UITableView().then {
        $0.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        $0.rowHeight = 56
    }
    
    private let logoutButton = UIButton().then {
        $0.setTitleColor(.devReelsColor.neutral70, for: .normal)
        $0.setTitle("< logout >", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.layer.borderColor = UIColor.devReelsColor.neutral70?.cgColor ?? UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 5
        $0.clipsToBounds = true
    }
    
    private let leftBackButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        $0.tintColor = UIColor.devReelsColor.neutral70
    }
    
    // MARK: - Properties
    
    let viewModel: SettingViewModel
    
    // MARK: - Init
    
    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - bind
    
    override func bind() {
        let input = SettingViewModel.Input(
            viewWillAppear: rx.viewWillAppear.map { _ in () }.asObservable(),
            logoutButtonTap: logoutButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            backButtonTap: leftBackButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            selectedSeting: tableView.rx.modelSelected(Setting.self)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.settingList
            .drive(tableView.rx.items(
                cellIdentifier: SettingTableViewCell.identifier,
                cellType: SettingTableViewCell.self)) { _, setting, cell in
                    cell.configureCell(setting: setting)
                    cell.selectionStyle = .none
                }
                .disposed(by: disposeBag)
        
        output.logoutAlert
            .emit(to: rx.presentAlert)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Layout
    
    override func layout() {
        layoutAttribute()
        
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        view.addSubview(logoutButton)
        
        logoutButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.height.equalTo(50)
        }
    }
    
    func layoutAttribute() {
        navigationItem.title = "설정"
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBackButton)
    }
    
    // MARK: - Methods
}
