//
//  DIContainer.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/09.
//  Copyright © 2023 DevReels. All rights reserved.
//

import Foundation
import Swinject

final class DIContainer {
    static let shared = DIContainer()
    let container = Container()
    private init() {}
    
    func inject() {
        registerDataSources()
        registerRepositories()
        registerUseCases()
        registerViewModels()
    }
    
    private func registerDataSources() {
        container.register(AuthServiceProtocol.self) { _ in FBAuthService() }
        container.register(ReelsDataSourceProtocol.self) { _ in ReelsDataSource() }
        container.register(KeychainProtocol.self) { _ in Keychain() }
        container.register(KeychainManagerProtocol.self) { resolver in
            var dataSource = KeychainManager()
            dataSource.keychain = resolver.resolve(KeychainProtocol.self)
            return dataSource
        }
        container.register(CommentDataSourceProtocol.self) { _ in CommentDataSource()}
        container.register(UserDataSourceProtocol.self) { _ in UserDataSource()}
        container.register(SettingDataSourceProtocol.self) { _ in SettingDataSource()}
    }
    
    private func registerRepositories() {
        container.register(AuthRepositoryProtocol.self) { resolver in
            var repository = AuthRepository()
            repository.authService = resolver.resolve(AuthServiceProtocol.self)
            return repository
        }
        container.register(ReelsRepositoryProtocol.self) { resolver in
            var repository = ReelsRepository()
            repository.reelsDataSource = resolver.resolve(ReelsDataSourceProtocol.self)
            return repository
        }
        
        container.register(TokenRepositoryProtocol.self) { resolver in
            var repository = TokenRepository()
            repository.keychainManager = resolver.resolve(KeychainManagerProtocol.self)
            return repository
        }
        
        container.register(CommentRepositoryProtocol.self) { resolver in
            var repository = CommentRepository()
            repository.commentDataSource = resolver.resolve(CommentDataSourceProtocol.self)
            return repository
        }
        
        container.register(UserRepositoryProtocol.self) { resolver in
            var repository = UserRepository()
            repository.userDataSource = resolver.resolve(UserDataSourceProtocol.self)
            repository.keyChainManager = resolver.resolve(KeychainManagerProtocol.self)
            return repository
        }
        
        container.register(SettingRepositoryProtocol.self) { resolver in
            var repository = SettingRepository()
            repository.settingDataSource = resolver.resolve(SettingDataSourceProtocol.self)
            return repository
        }
    }
    
    private func registerUseCases() {
        container.register(LoginUseCaseProtocol.self) { resolver in
            var useCase = LoginUseCase()
            useCase.authRepository = resolver.resolve(AuthRepositoryProtocol.self)
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        
        container.register(ReelsUseCaseProtocol.self) { resolver in
            var useCase = ReelsUseCase()
            useCase.reelsRepository = resolver.resolve(ReelsRepositoryProtocol.self)
            return useCase
        }
        
        container.register(UploadReelsUsecaseProtocol.self) { resolver in
            var useCase = UploadReelsUseCase()
            useCase.reelsRepository = resolver.resolve(ReelsRepositoryProtocol.self)
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            return useCase
        }
        
        container.register(CommentListUseCaseProtocol.self) { resolver in
            var useCase = CommentListUseCase()
            useCase.commentRepository = resolver.resolve(CommentRepositoryProtocol.self)
            return useCase
        }
        
        container.register(LoginCheckUseCaseProtocol.self) { resolver in
            var useCase = LoginCheckUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        
        container.register(CommentUploadUseCaseProtocol.self) { resolver in
            var useCase = CommentUploadUseCase()
            useCase.commentRepository = resolver.resolve(CommentRepositoryProtocol.self)
            return useCase
        }
        
        container.register(UserUseCaseProtocol.self) { resolver in
            var useCase = UserUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        
        container.register(ProfileUseCaseProtocol.self) { resolver in
            var useCase = ProfileUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        
        container.register(EditProfileUseCaseProtocol.self) { resolver in
            var useCase = EditProfileUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
        
        container.register(HyperLinkUseCaseProtocol.self) { _ in HyperLinkUseCase() }
        
        container.register(SettingUseCaseProtocol.self) { resolver in
            var useCase = SettingUseCase()
            useCase.settingRepository = resolver.resolve(SettingRepositoryProtocol.self)
            return useCase
        }
        
        container.register(LogoutUseCaseProtocol.self) { resolver in
            var useCase = LogoutUseCase()
            useCase.tokenRepository = resolver.resolve(TokenRepositoryProtocol.self)
            return useCase
        }
        
        container.register(AutoLoginUseCaseProtocol.self) { resolver in
            var useCase = AutoLoginUseCase()
            useCase.userRepository = resolver.resolve(UserRepositoryProtocol.self)
            return useCase
        }
    }
    
    private func registerViewModels() {
        container.register(LoginViewModel.self) { resolver in
            let viewModel = LoginViewModel()
            viewModel.loginUseCase = resolver.resolve(LoginUseCaseProtocol.self)
            viewModel.autologinUseCase = resolver.resolve(AutoLoginUseCaseProtocol.self)
            return viewModel
        }
        
        container.register(ReelsViewModel.self) { resolver in
            let viewModel = ReelsViewModel()
            viewModel.userUseCase = resolver.resolve(UserUseCaseProtocol.self)
            viewModel.reelsUseCase = resolver.resolve(ReelsUseCaseProtocol.self)
            
            return viewModel
        }
        
        container.register(VideoTrimmerViewModel.self) { _ in VideoTrimmerViewModel() }
        
        container.register(VideoDetailsViewModel.self) { resolver in
            let viewModel = VideoDetailsViewModel()
            viewModel.uploadReelsUsecase = resolver.resolve(UploadReelsUsecaseProtocol.self)
           
            return viewModel
        }
        
        container.register(ProfileViewModel.self) { resolver in
            let viewModel = ProfileViewModel()
            viewModel.userUseCase = DIContainer.shared.container.resolve(UserUseCaseProtocol.self)
            viewModel.profileUseCase = DIContainer.shared.container.resolve(ProfileUseCaseProtocol.self)
            viewModel.reelsUseCase = DIContainer.shared.container.resolve(ReelsUseCaseProtocol.self)
            viewModel.hyperlinkUseCase = DIContainer.shared.container.resolve(HyperLinkUseCaseProtocol.self)
            
            return viewModel
        }
        
        container.register(ProfileCellViewModel.self) { resolver in
            let viewModel = ProfileCellViewModel()
            viewModel.commentListUseCase = resolver.resolve(CommentListUseCaseProtocol.self)
            
            return viewModel
        }
        
        container.register(CommentViewModel.self) { resolver in
            let viewModel = CommentViewModel()
            viewModel.commentListUseCase = resolver.resolve(CommentListUseCaseProtocol.self)
            viewModel.commentUploadUseCase = resolver.resolve(CommentUploadUseCaseProtocol.self)
            viewModel.loginCheckUseCase = resolver.resolve(LoginCheckUseCaseProtocol.self)
            viewModel.userUseCase = resolver.resolve(UserUseCaseProtocol.self)
            return viewModel
        }
    
        container.register(SettingViewModel.self) { resolver in
            let viewModel = SettingViewModel()
            viewModel.settingUsecase = resolver.resolve(SettingUseCaseProtocol.self)
            viewModel.hyperlinkUseCase = resolver.resolve(HyperLinkUseCaseProtocol.self)
            viewModel.logoutUseCase = resolver.resolve(LogoutUseCaseProtocol.self)
            return viewModel
        }
            
        container.register(EditProfileViewModel.self) { resolver in
            let viewModel = EditProfileViewModel()
            viewModel.editProfileUseCase = resolver.resolve(EditProfileUseCaseProtocol.self)
            return viewModel
        }
    }
}
