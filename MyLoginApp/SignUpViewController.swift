//
//  SignUpViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(signUpView)
        signUpView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        textFieldSetup()
        
        updateSignUpButtonState()
    }
}

// MARK: - 유효성 검사 로직
extension SignUpViewController {
    
    /// 이메일 유효성 검사 메서드
    /// - 숫자로 시작 불허
    /// - @앞은 6~20글자이면서 영문자 소문자와 숫자만 허용
    func validateEmail(_ email: String?) -> Bool {
        guard let email = email, !email.isEmpty else { return false }
        let emailRegex = "^[a-z0-9]{5,19}+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    /// 비밀번호 유효성 검사 메서드
    /// - 8글자 이상
    func validatePassword(_ password: String?) -> Bool {
        guard let password = password, password.count >= 8 else { return false }
        return true
    }
    
    /// 닉네임 유효성 검사 메서드
    /// - 1글자 이상
    func validateNickname(_ nickname: String?) -> Bool {
        guard let nickname = nickname, !nickname.isEmpty else { return false }
        return true
    }
    
    /// 회원가입 버튼 활성화 메서드
    func updateSignUpButtonState() {
        let isEmailValid = validateEmail(signUpView.emailTextField.text)
        let isPwValid = validatePassword(signUpView.pwTextField.text)
        let isCheckPwValid = signUpView.pwTextField.text == signUpView.checkPwTextField.text && !signUpView.checkPwTextField.text!.isEmpty
        let isNicknameValid = validateNickname(signUpView.nickNameTextField.text)
        
        let allFieldValid = isEmailValid && isPwValid && isCheckPwValid && isNicknameValid
        signUpView.signUpButton.isEnabled = allFieldValid
    }
    
    /// 비밀번호 일치 검사 메서드
    func checkPassword() {
        let isMatch = signUpView.pwTextField.text == signUpView.checkPwTextField.text
        let isNotEmpty = !(signUpView.pwTextField.text?.isEmpty ?? true) && !(signUpView.checkPwTextField.text?.isEmpty ?? true)
        
        if isMatch && isNotEmpty { // 입력도 되고, 일치할 경우
            signUpView.checkPwAlertLabel.text = ""
            signUpView.checkPwAlertLabel.isHidden = true
            signUpView.checkPwUnderlineView.backgroundColor = .lightGray
        } else if !isMatch && isNotEmpty { // 입력은 됐는데 불일치일 경우
            signUpView.checkPwAlertLabel.text = "비밀번호가 일치하지 않습니다."
            signUpView.checkPwAlertLabel.isHidden = false
            signUpView.checkPwUnderlineView.backgroundColor = .red
        } else { // 비어있거나 아직 입력중일 경우
            signUpView.checkPwAlertLabel.isHidden = true
            signUpView.checkPwUnderlineView.backgroundColor = .lightGray
        }
    }
}

// MARK: - 텍스트필드 메서드

extension SignUpViewController: UITextFieldDelegate {
    private func textFieldSetup() {
        signUpView.emailTextField.delegate = self
        signUpView.pwTextField.delegate = self
        signUpView.checkPwTextField.delegate = self
        signUpView.nickNameTextField.delegate = self
    }
    
    // 실시간 유효성 검사
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        // 이메일 필드 유효성 검사
        if textField == signUpView.emailTextField {
            if validateEmail(textField.text) {
                signUpView.emailAlertLabel.isHidden = true
                signUpView.emailUnderlineView.backgroundColor = .lightGray
            } else {
                signUpView.emailAlertLabel.isHidden = false
                signUpView.emailAlertLabel.text = "올바른 이메일 형식이 아닙니다."
                signUpView.emailUnderlineView.backgroundColor = .red
            }
        }
        
        // 비밀번호 필드 유효성 검사
        if textField == signUpView.pwTextField {
            if validatePassword(textField.text) {
                signUpView.pwAlertLabel.isHidden = true
                signUpView.pwUnderlineView.backgroundColor = .lightGray
            } else {
                signUpView.pwAlertLabel.isHidden = false
                signUpView.pwAlertLabel.text = "비밀번호는 8자리 이상이어야 합니다."
                signUpView.pwUnderlineView.backgroundColor = .red
            }
            
            checkPassword()
        }
        
        // 비밀번호 확인 필드 일치 여부 검사
        if textField == signUpView.checkPwTextField {
            checkPassword()
        }
        
        // 닉네임 필드 유효성 검사
        if textField == signUpView.nickNameTextField {
            if validateNickname(textField.text) {
                signUpView.nickNameAlertLabel.isHidden = true
                signUpView.nickNameAlertLabel.backgroundColor = .lightGray
            } else {
                signUpView.nickNameAlertLabel.isHidden = false
                signUpView.nickNameTextField.text = "닉네임은 1글자 이상이어야 합니다."
                signUpView.nickNameAlertLabel.backgroundColor = .lightGray
            }
        }
        
        // 필드 상태에 따라 회원가입 버튼 활성화
        updateSignUpButtonState()
    }
    
    // return키 동작 처리
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == signUpView.emailTextField {
            signUpView.pwTextField.becomeFirstResponder() // 이메일 -> 비밀번호
        } else if textField == signUpView.pwTextField {
            signUpView.checkPwTextField.becomeFirstResponder() // 비밀번호 -> 비밀번호 확인
        } else if textField == signUpView.checkPwTextField {
            signUpView.nickNameTextField.becomeFirstResponder() // 비밀번호 확인 -> 닉네임
        } else if textField == signUpView.nickNameTextField {
            textField.resignFirstResponder() // 닉네임 필드에서 키보드 내림
        }
        return true
    }
    
    // 다른 곳 터치시 키보드 내림
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
