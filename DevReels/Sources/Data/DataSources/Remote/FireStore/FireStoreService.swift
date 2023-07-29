//
//  FireStoreService.swift
//  DevReels
//
//  Created by HoJun on 2023/07/11.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import Firebase

enum FireStoreError: Error, LocalizedError {
    case unknown
    case decodeError
}


final class FireSotreService: FireStoreServiceProtocol {
    
    // MARK: - Properties
    
    private let database: Firestore
    
    init(database: Firestore = Firestore.firestore()) {
        self.database = database
    }
    
    
    // MARK: - Methods

    public func getDocument(collection: FireStoreCollection, document: String) -> Single<FirebaseData> {
        return Single<FirebaseData>.create { [weak self] single in
            guard let self else { return Disposables.create() }
            
            self.database.collection(collection.name).document(document).getDocument { snapshot, error in
                if let error = error { single(.failure(error)) }
                
                guard let snapshot = snapshot, let data = snapshot.data() else {
                    single(.failure(FireStoreError.unknown))
                    return
                }
                single(.success(data))
            }
            return Disposables.create()
        }
    }
}
