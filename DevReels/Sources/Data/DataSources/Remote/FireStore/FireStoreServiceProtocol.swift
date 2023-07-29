//
//  FireStoreServiceProtocol.swift
//  DevReels
//
//  Created by HoJun on 2023/07/11.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift

protocol FireStoreServiceProtocol {
    
    typealias FirebaseData = [String:Any]
    
    func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData>
}
