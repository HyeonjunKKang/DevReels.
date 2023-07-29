//
//  ViewModelType.swift
//  DevReels
//
//  Created by Sh Hong on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift

protocol ViewModel {
    associatedtype Input
    associatedtype Output

    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
