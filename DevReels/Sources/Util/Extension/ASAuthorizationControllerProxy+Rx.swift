//
//  ASAuthorizationControllerProxy+Rx.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/24.
//  Copyright © 2023 DevReels. All rights reserved.
//

import AuthenticationServices
import RxSwift
import RxCocoa

class ASAuthorizationControllerProxy: DelegateProxy<ASAuthorizationController, ASAuthorizationControllerDelegate>, DelegateProxyType {
    
    // MARK: - Properties
    private var presentationWindow = UIWindow()
    internal lazy var didComplete = PublishSubject<ASAuthorization>()
    
    
    // MARK: - Initializers
    public init(controller: ASAuthorizationController) {
        super.init(parentObject: controller, delegateProxy: ASAuthorizationControllerProxy.self)
    }
    
    // MARK: - Methods
    static func registerKnownImplementations() {
        self.register {
            ASAuthorizationControllerProxy(controller: $0)
        }
    }
    
    static func currentDelegate(for object: ASAuthorizationController) -> ASAuthorizationControllerDelegate? {
        return object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: ASAuthorizationControllerDelegate?, to object: ASAuthorizationController) {
        object.delegate = delegate
    }
    
    // MARK: - Completed
    deinit {
        self.didComplete.onCompleted()
    }
}

// MARK: - ASAuthorizationControllerDelegate
extension ASAuthorizationControllerProxy: ASAuthorizationControllerDelegate {
    
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        didComplete.onNext(authorization)
        didComplete.onCompleted()
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        if (error as NSError).code == ASAuthorizationError.canceled.rawValue {
            didComplete.onCompleted()
            return
        }
        didComplete.onError(error)
    }
}

// MARK: - ASAuthorizationControllerPresentationContextProviding
extension ASAuthorizationControllerProxy: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.presentationWindow
    }
}

extension Reactive where Base: ASAuthorizationAppleIDProvider {
    
    public func login(scope: [ASAuthorization.Scope]? = nil) -> Observable<ASAuthorization> {
        let request = base.createRequest()
        request.requestedScopes = scope
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        let proxy = ASAuthorizationControllerProxy.proxy(for: controller)
        
        controller.presentationContextProvider = proxy
        controller.performRequests()
        
        return proxy.didComplete
    }
}
