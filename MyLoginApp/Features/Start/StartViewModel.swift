//
//  StartViewModel.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/11/25.
//

import Foundation

final class StartViewModel {
    private let userService: UserService
    
    // MARK: - Input
    var inputEmail: String = ""
    var inputPassword: String = ""
    
    // 로그인 버튼 탭 시 호출
    func loginButtonTapped() {
        tryLogin()
    }
    
    // MARK: - Output
    var onLoginSuccess: ((String) -> Void)?
    var onLoginFailure: ((LoginFailureReason) -> Void)?
    var onNavigateToSignUp: (() -> Void)?
    
    // MARK: - 초기화
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    // 로그인 시도
    func tryLogin() {
        guard !inputEmail.isEmpty && !inputPassword.isEmpty else {
            onLoginFailure?(.emptyFields)
            return
        }
        
        do {
            if let user = try userService.getUser(email: inputEmail) {
                if user.password == inputPassword {
                    LoginSessionManager.logIn(email: user.email)
                    onLoginSuccess?(user.email)
                } else {
                    onLoginFailure?(.wrongPassword)
                }
            } else {
                onLoginFailure?(.userNotFound)
                onNavigateToSignUp?()
            }
        } catch let error as UserServiceError {
            onLoginFailure?(.serviceError)
        } catch {
            onLoginFailure?(.serviceError)
        }
    }
}
