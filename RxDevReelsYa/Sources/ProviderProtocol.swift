//
//  ProviderProtocol.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/22.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

public protocol ProviderProtocol: AnyObject {
    func request<T: Decodable>(_ urlConvertible: URLRequestConvertible) -> Observable<T>
}
