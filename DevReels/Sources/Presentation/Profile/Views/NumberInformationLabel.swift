////
////  NumberInformationLabel.swift
////  DevReels
////
////  Created by Sh Hong on 2023/06/14.
////  Copyright © 2023 DevReels. All rights reserved.
////
//

// MARK: - 삭제필요
//import UIKit
//
//final class NumberInformationLabel: UIView {
//    
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 12)
//        return label
//    }()
//    
//    private let countLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(
//            ofSize: 14,
//            weight: .semibold
//        )
//        return label
//    }()
//    
//    init(title: String, count: Int) {
//        super.init(frame: .zero)
//        
//        configure()
//        self.titleLabel.text = title
//        self.countLabel.text = "\(count)"
//    }
//    
//    required init(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//    
//    private func configure() {
//        self.axis = .horizontal
//        self.alignment = .center
//        self.spacing = 4
//    }
//    
//}
