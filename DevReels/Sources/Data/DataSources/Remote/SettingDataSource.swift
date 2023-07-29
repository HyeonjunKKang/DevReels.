//
//  SettingDataSource.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/20.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import RxSwift
import FirebaseFirestore

struct SettingDataSource: SettingDataSourceProtocol {
    
    let firestore = Firestore.firestore().collection("setting")
    
    func fetch() -> Observable<[SettingResponseDTO]> {
        return Observable.create { emitter in
            firestore.getDocuments { snapshot, _ in
                if let documents = snapshot?.documents {
                    let setting = documents
                        .map { $0.data() }
                        .compactMap { try? JSONSerialization.data(withJSONObject: $0) }
                        .compactMap { try? JSONDecoder().decode(Setting.self, from: $0) }
                        .map { SettingResponseDTO(setting: $0) }
                        .sorted { $0.order < $1.order }
                    
                    emitter.onNext(setting)
                }
            }
            
            return Disposables.create()
        }
    }
}
