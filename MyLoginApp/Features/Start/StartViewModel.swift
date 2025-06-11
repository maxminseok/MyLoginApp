//
//  StartViewModel.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/11/25.
//

import Foundation

enum LoginFailureReason {
    case emptyFields
    case userNotFound
    case wrongPassword
    case serviceError
    
    var message: String {
        switch self {
        case .emptyFields: return "이메일과 비밀번호를 모두 입력해주세요."
        case .userNotFound: return "존재하지 않는 사용자입니다."
        case .wrongPassword: return "비밀번호가 틀렸습니다."
        case .serviceError: return "사용자 정보를 불러오는데 실패했습니다."
        }
    }
}

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
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
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
