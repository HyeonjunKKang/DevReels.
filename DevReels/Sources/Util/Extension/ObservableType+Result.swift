//
//  ObservableType.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/23.
//  Copyright © 2023 DevReels. All rights reserved.
//

import RxSwift

extension ObservableType {
    func asResult() -> Observable<Result<Element, Error>> {
        return self.map { .success($0) }
            .catch { .just(.failure($0)) }
    }
}
