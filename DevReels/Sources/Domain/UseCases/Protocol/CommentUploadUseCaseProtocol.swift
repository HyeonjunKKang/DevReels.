//
//  CommentUploadUseCaseProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentUploadUseCaseProtocol {
    func upload(comment: Comment) -> Observable<Void>
    func delete(comment: Comment) -> Observable<Void>
}
