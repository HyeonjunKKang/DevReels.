//
//  RxUIViewController+Alert.swift
//  DevReels
//
//  Created by 강현준 on 2023/07/04.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

extension Reactive where Base: UIViewController {
    var presentAlert: Binder<Alert> {
        return Binder(base) { base, alert in
            let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                alert.observer?.onNext(true)
                alert.observer?.onCompleted()
            })
            let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                alert.observer?.onCompleted()
            })
            alertController.addAction(okAction)
            alertController.addAction(cancleAction)
            base.present(alertController, animated: true)
        }
    }
    
    var presentActionSheet: Binder<Alert> {
        return Binder(base) { base, alert in
            let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: .actionSheet)
            
            let okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                alert.observer?.onNext(true)
                alert.observer?.onCompleted()
            })
            let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                alert.observer?.onCompleted()
            })
            alertController.addAction(okAction)
            alertController.addAction(cancleAction)
            base.present(alertController, animated: true)
        }
    }
}

extension UIViewController {
    func actionsheet(title: String, message: String, actions: [UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}
