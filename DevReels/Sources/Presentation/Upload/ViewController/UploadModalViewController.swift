//
//  UploadModalViewController.swift
//  DevReels
//
//  Created by HoJun on 2023/07/03.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation

import UIKit

import RxCocoa
import RxSwift

final class UploadModalViewController: ViewController {
    
    enum Constant {
        static let cellHeight = 40.0
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "릴스 만들기"
        $0.font = UIFont.systemFont(ofSize: 24)
    }
    
    private let closeButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark"), for: .normal)
        $0.tintColor = .white
    }
    
    private let tableView = UITableView().then {
        $0.register(UploadModalCell.self, forCellReuseIdentifier: UploadModalCell.identifier)
        $0.rowHeight = Constant.cellHeight
        $0.backgroundColor = .devReelsColor.backgroundDefault
        $0.separatorStyle = .none
    }
    
    private let viewModel: UploadModalViewModel
        
    init(viewModel: UploadModalViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func bind() {
        let input = UploadModalViewModel.Input(
            itemSelected: tableView.rx.modelSelected(UploadModalItem.self)
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance),
            closeButtonTapped: closeButton.rx.tap
                .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
        )
        
        let output = viewModel.transform(input: input)
        
        output.items
            .drive(tableView.rx.items(
                cellIdentifier: UploadModalCell.identifier,
                cellType: UploadModalCell.self
            )) { _, modalItem, cell in
                cell.prepareForReuse()
                cell.configure(modalItem: modalItem)
            }
            .disposed(by: disposeBag)
    }
    
    override func layout() {
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        view.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(30)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
    }
}
