//
//  CommentDataSourceProtocol.swift
//  DevReels
//
//  Created by 강현준 on 2023/06/30.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol CommentDataSourceProtocol {
    func upload(request: CommentRequestDTO) -> Observable<Void>
    func read(reelsID: String) -> Observable<[CommentResponseDTO]>
    func delete(request: CommentRequestDTO) -> Observable<Void>
}
