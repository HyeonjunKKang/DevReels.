//
//  HyperlinkUseCase.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

struct HyperLinkUseCase: HyperLinkUseCaseProtocol {
    
    func openSafari(urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url, completionHandler: { _ in
               
            })
        }
    }
}
