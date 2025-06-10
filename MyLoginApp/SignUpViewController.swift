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
    private let viewModel = SignUpViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(signUpView)
        signUpView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        textFieldSetup()
        bindings() // ViewModel과 View 바인딩 설정 메서드 추가
        setupActions() // 버튼 액션 설정 메서드 추가
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
    
    // 텍스트 필드 내용이 변경될 때마다 뷰모델에 전달
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == signUpView.emailTextField {
            viewModel.email = textField.text ?? ""
        } else if textField == signUpView.pwTextField {
            viewModel.password = textField.text ?? ""
        } else if textField == signUpView.checkPwTextField {
            viewModel.checkPassword = textField.text ?? ""
        } else if textField == signUpView.nickNameTextField {
            viewModel.nickname = textField.text ?? ""
        }
        // 뷰모델의 didSet이 호출되어 validateInputs()가 실행되고,그 결과로 바인딩된 클로저들이 호출되어 UI가 업데이트
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


// MARK: - 바인딩
extension SignUpViewController {
    private func bindings() {
        // 이메일 유효성 검사 결과 바인딩
        viewModel.onEmailValidationUpdated = { [weak self] errorMessage in
            guard let self = self else { return }
            self.signUpView.emailAlertLabel.text = errorMessage
            self.signUpView.emailAlertLabel.isHidden = (errorMessage == nil)
            self.signUpView.emailUnderlineView.backgroundColor = (errorMessage == nil) ? .lightGray : .red
        }
        
        // 비밀번호 유효성 검사 결과 바인딩
        viewModel.onPasswordValidationUpdated = { [weak self] errorMessage in
            guard let self = self else { return }
            self.signUpView.pwAlertLabel.text = errorMessage
            self.signUpView.pwAlertLabel.isHidden = (errorMessage == nil)
            self.signUpView.pwUnderlineView.backgroundColor = (errorMessage == nil) ? .lightGray : .red
        }
        
        // 비밀번호 일치 여부 결과 바인딩
        viewModel.onCheckPasswordMatchUpdated = { [weak self] errorMessage in
            guard let self = self else { return }
            self.signUpView.checkPwAlertLabel.text = errorMessage
            self.signUpView.checkPwAlertLabel.isHidden = (errorMessage == nil)
            self.signUpView.checkPwUnderlineView.backgroundColor = (errorMessage == nil) ? .lightGray : .red
        }
        
        // 닉네임 유효성 검사 결과 바인딩
        viewModel.onNicknameValidationUpdated = { [weak self] errorMessage in
            guard let self = self else { return }
            self.signUpView.nickNameAlertLabel.text = errorMessage
            self.signUpView.nickNameAlertLabel.isHidden = (errorMessage == nil)
            self.signUpView.nickNameUnderlineView.backgroundColor = (errorMessage == nil) ? .lightGray : .red
        }
        
        // 회원가입 버튼 활성화 상태 바인딩
        viewModel.onSignUpButtonStateUpdated = { [weak self] in
            guard let self = self else { return }
            self.signUpView.signUpButton.isHidden = !self.viewModel.isSignUpButtonEnabled
            // 또는 self.signUpView.signUpButton.isEnabled = self.viewModel.isSignUpButtonEnabled
        }
        
        // 회원가입 성공 시 바인딩
        viewModel.onSignUpSuccess = { [weak self] in
            guard let self = self else { return }
            // 회원가입 성공 시 처리 로직 (예: 알림창 띄우고 로그인 화면으로 이동)
            let alert = UIAlertController(title: "회원가입 성공", message: "환영합니다!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                // 로그인 화면으로 이동하거나 홈 화면으로 이동
                self.dismiss(animated: true, completion: nil) // 현재 화면 닫기 예시
            }))
            self.present(alert, animated: true)
            
            // 작업 완료 시 버튼 다시 활성화
            self.signUpView.signUpButton.isEnabled = true
            self.signUpView.signUpButton.alpha = 1.0
        }
        
        // 회원가입 실패 시 바인딩
        viewModel.onSignUpFailure = { [weak self] errorType, message in
            guard let self = self else { return }
            // 회원가입 실패 시 알림창 띄우기
            let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("회원가입 실패: \(errorType) - \(message)")
            
            // 작업 완료 시 버튼 다시 활성화
            self.signUpView.signUpButton.isEnabled = true // 다시 활성화
            self.signUpView.signUpButton.alpha = 1.0 // 원상 복구
        }
    }
    
    private func setupActions() {
        // 회원가입 버튼 액션 연결
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc private func signUpButtonTapped() {
        // 버튼 비활성화 (중복 클릭 방지)
        signUpView.signUpButton.isEnabled = false
        signUpView.signUpButton.alpha = 0.5 // 비활성화 시 시각적 피드백
        
        viewModel.signUp() // 뷰모델에 회원가입 요청
    }
}
