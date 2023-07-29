//
//  LoginViewController.swift
//  DevReels
//
//  Created by 강현준 on 2023/05/15.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

import Firebase

import AuthenticationServices
import CryptoKit

import SafariServices
import Alamofire


struct Alert {
    let title: String
    let message: String
    let observer: AnyObserver<Bool>?
}

final class LoginViewController: ViewController {
    
    fileprivate var currentNonce: String?
    
    enum Constant {
        static let padding: CGFloat = 40
    }
    
    struct Layout {
        static let LoginButtonHeight: CGFloat = 50
    }
    
    // MARK: - Properties
    
    let logoView = LogoView()
    
    private let appleLoginButton = LoginButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(UIColor.devReelsColor.primary90 ?? UIColor.orange, for: .normal)
        $0.setTitle("애플 로그인", for: .normal)
        $0.snp.makeConstraints {
            $0.height.equalTo(Layout.LoginButtonHeight)
        }
    }
    
    private let githubLoginButton = LoginButton().then {
        $0.setTitle("깃허브 로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(UIColor.devReelsColor.primary90 ?? UIColor.orange, for: .normal)
        $0.snp.makeConstraints {
            $0.height.equalTo(Layout.LoginButtonHeight)
        }
    }
    
    private let viewModel: LoginViewModel
    
    // MARK: - Initializer
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Method
    
    override func layout() {
        view.backgroundColor = UIColor.devReelsColor.neutral30
        attribute()
        layoutLogo()
        layoutLoginButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func bind() {
        let credential = appleLoginButton.rx.tap
            .flatMap {
                ASAuthorizationAppleIDProvider().rx.login(scope: [.email])
            }
            .withUnretained(self)
            .compactMap { controller, authorization in
                controller.generateOAuthCredential(authorization: authorization)
            }
        
        let input = LoginViewModel.Input(
            appleCredential: credential,
            viewWillAppear: rx.viewWillAppear.map { _ in () }
        )
        
        viewModel.transform(input: input)
    }

    func startGitHubLogin() {
    }
    
    private func attribute() {
        self.title = "{DevReels}"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.devReelsColor.primary90]
        self.backButton.isHidden = true
    }
    
    private func layoutLogo() {
        view.addSubview(logoView)
        
        logoView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(67)
            $0.leading.trailing.equalToSuperview().inset(89)
            $0.height.equalTo(212)
        }
    }
    
    private func layoutLoginButton() {
        let buttonStackView = createButtonStackView()
        
        view.addSubview(buttonStackView)
        
        buttonStackView.snp.makeConstraints{
            $0.top.equalTo(logoView.snp.bottom).offset(67)
            $0.left.right.equalToSuperview().inset(Constant.padding)
        }
    }
    
    private func createButtonStackView() -> UIStackView {
        return UIStackView(arrangedSubviews: [appleLoginButton, githubLoginButton]).then {
            $0.axis = .vertical
            $0.spacing = 16
        }
    }
}

extension LoginViewController{
    private func generateOAuthCredential(authorization: ASAuthorization) -> OAuthCredential? {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let nonce = generateRandomNonce().toSha256()
            
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return nil
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return nil
            }
            
            guard
                let authorizationCode = appleIDCredential.authorizationCode,
                let codeString = String(data: authorizationCode, encoding: .utf8)
            else {
                print("Unable to serialize token string from authorizationCode")
                return nil
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
            
            return credential
        }
        return nil
    }
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func generateRandomNonce(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
