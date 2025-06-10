//
//  SignUpViewModel.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/11/25.
//

import Foundation

// ViewModel의 상태 변화를 View로 전달하기 위한 클로저 타입 정의
// 뷰모델의 프로퍼티가 변경될 때마다 호출될 클로저
typealias UpdateHandler = () -> Void

final class SignUpViewModel {
    
    private let userService: UserService
    
    // MARK: - Input 프로퍼티 (뷰 컨트롤러로부터 입력받을 값)
    var email: String = "" { didSet { validateEmailField() } }
    var password: String = "" { didSet { validatePasswordField() } }
    var checkPassword: String = "" { didSet { validateCheckPasswordField() } }
    var nickname: String = "" { didSet { validateNicknameField() } }
    
    // MARK: - Internal Validation States (내부 상태 프로퍼티)
    private var _isEmailValid: Bool = false { didSet { updateSignUpButtonState() } } // 유효성 변경 시 버튼 상태 업데이트
    private var _isPasswordValid: Bool = false { didSet { updateSignUpButtonState() } }
    private var _isCheckPasswordMatching: Bool = false { didSet { updateSignUpButtonState() } }
    private var _isNicknameValid: Bool = false { didSet { updateSignUpButtonState() } }
    
    
    // MARK: - Output 프로퍼티 (뷰 컨트롤러에게 전달할 상태)
    var onEmailValidationUpdated: ((String?) -> Void)? // 이메일 유효성 검사 결과
    var onPasswordValidationUpdated: ((String?) -> Void)? // 비밀번호 유효성 검사 결과
    var onCheckPasswordMatchUpdated: ((String?) -> Void)? // 비밀번호 일치 여부 결과
    var onNicknameValidationUpdated: ((String?) -> Void)? // 닉네임 유효성 검사 결과
    
    var isSignUpButtonEnabled: Bool = false { // 회원가입 버튼 활성화 여부
        didSet {
            // 버튼 활성화 상태가 변경될 때만 알림
            if oldValue != isSignUpButtonEnabled {
                onSignUpButtonStateUpdated?()
            }
        }
    }
    
    var onSignUpButtonStateUpdated: UpdateHandler? // 회원가입 버튼 활성화 상태 업데이트 알림
    
    var onSignUpSuccess: UpdateHandler? // 회원가입 성공 시 알림
    var onSignUpFailure: ((UserServiceError, String) -> Void)? // 회원가입 실패 시 알림 (에러 타입, 메시지)
    
    // MARK: - 초기화
    init(userService: UserService = UserService()) {
        self.userService = userService
    }
    
    // MARK: - 유효성 검사 로직
    
    /// 모든 입력 필드의 유효성 검사를 수행하고, 각 상태를 업데이트합니다.
    private func validateEmailField() {
        _isEmailValid = validateEmailFormat(email)
        onEmailValidationUpdated?(_isEmailValid ? nil : "올바른 이메일 형식이 아닙니다.")
    }
    
    private func validatePasswordField() {
        _isPasswordValid = validatePasswordFormat(password)
        onPasswordValidationUpdated?(_isPasswordValid ? nil : "비밀번호는 8자리 이상이어야 합니다.")
        // 비밀번호가 변경되면 비밀번호 확인도 다시 검사해야 합니다.
        validateCheckPasswordField()
    }
    
    private func validateCheckPasswordField() {
        _isCheckPasswordMatching = validateCheckPasswordMatch(password, checkPassword)
        onCheckPasswordMatchUpdated?(_isCheckPasswordMatching ? nil : "비밀번호가 일치하지 않습니다.")
    }
    
    private func validateNicknameField() {
        _isNicknameValid = validateNicknameFormat(nickname)
        onNicknameValidationUpdated?(_isNicknameValid ? nil : "닉네임은 1글자 이상이어야 합니다.")
    }
    
    /// 유효성 검사 메서드들이 Bool을 직접 반환
    private func validateEmailFormat(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailRegex = "^[a-z0-9]{5,19}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePasswordFormat(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        return true
    }
    
    private func validateCheckPasswordMatch(_ password: String, _ checkPassword: String) -> Bool {
        // 비밀번호 확인 필드도 비어있지 않아야 하고, 두 비밀번호가 일치해야 함
        return !checkPassword.isEmpty && (password == checkPassword)
    }
    
    private func validateNicknameFormat(_ nickname: String) -> Bool {
        return !nickname.isEmpty
    }
    
    /// 모든 유효성 검사 결과를 종합하여 회원가입 버튼 활성화 여부를 결정합니다.
    private func updateSignUpButtonState() {
        let allFieldsFilled = !email.isEmpty && !password.isEmpty && !checkPassword.isEmpty && !nickname.isEmpty
        
        isSignUpButtonEnabled = _isEmailValid && _isPasswordValid && _isCheckPasswordMatching && _isNicknameValid && allFieldsFilled
    }
    
    // MARK: - Actions (뷰 컨트롤러가 호출할 액션)
    
    /// 회원가입 요청을 처리합니다.
    func signUp() {
        // 최종 유효성 검사 (ViewModel 내부 상태를 바탕으로)
        guard _isEmailValid && _isPasswordValid && _isCheckPasswordMatching && _isNicknameValid else {
            onSignUpFailure?(.registrationFailed(message: nil), "모든 필드를 올바르게 입력해주세요.")
            return
        }
        
        // 모든 로컬 유효성 검사를 통과하면, UserService를 통해 이메일 중복 확인 및 회원가입 시도
        Task {
            do {
                let isDuplicated = try await userService.isEmailDuplicated(email)
                if isDuplicated {
                    onSignUpFailure?(.duplicateEmail, "이미 사용 중인 이메일입니다.")
                    return
                }
                
                let userDTO = UserDTO(email: email, password: password, nickname: nickname)
                try await userService.registerUser(userDTO)
                
                onSignUpSuccess?()
                
            } catch let error as UserServiceError {
                onSignUpFailure?(error, error.message ?? "알 수 없는 오류가 발생했습니다.")
            } catch {
                onSignUpFailure?(.registrationFailed(message: nil), "알 수 없는 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")
            }
        }
    }
}
