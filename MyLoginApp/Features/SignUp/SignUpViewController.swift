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

    // 현재 활성화된 텍스트 필드를 저장할 변수
    private var activeTextField: UITextField?
    
    // 로딩 인디케이터
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(signUpView)
        signUpView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        self.view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        textFieldSetup()
        bindings() // ViewModel과 View 바인딩 설정 메서드 추가
        setupActions() // 버튼 액션 설정 메서드 추가
        setupTapGestureForKeyboardDismissal() // 키보드 내리기 제스처
        registerForKeyboardNotifications() // 키보드 알림 등록
        
        print("[SignUpViewController] isLoggedIn: \(LoginSessionManager.isLoggedIn)")
        print("[SignUpViewController] lastLoginEmail: \(LoginSessionManager.lastLoginEmail ?? "이메일 없음")")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - 버튼 설정

extension SignUpViewController {
    // 회원가입 버튼 액션 설정
    private func setupActions() {
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    // 회원가입 버튼 동작 처리
    @objc private func signUpButtonTapped() {
        // 버튼 비활성화(중복 클릭 방지)
        signUpView.signUpButton.isEnabled = false
        signUpView.signUpButton.alpha = 0.5
        activityIndicator.startAnimating()
        
        viewModel.signUp() // 뷰모델에 회원가입 요청
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
    
    // 텍스트 필드 편집 시작 시 호출
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    // 텍스트 필드 편집 종료 시 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
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

// MARK: - 키보드 처리

extension SignUpViewController {
    
    // MARK: - 키보드 내리기
    private func setupTapGestureForKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        signUpView.scrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // MARK: - 키보드 인식
    
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let keyboardHeight = keyboardFrame.height
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
        
        UIView.animate(withDuration: animationDuration) {
            self.signUpView.scrollView.contentInset = contentInsets
            self.signUpView.scrollView.scrollIndicatorInsets = contentInsets
            
            // 현재 활성화된 텍스트 필드가 키보드에 가려지는지 확인하고 스크롤 조정
            if let activeTextField = self.activeTextField {
                let rect = self.signUpView.scrollView.convert(activeTextField.bounds, from: activeTextField)
                self.signUpView.scrollView.scrollRectToVisible(rect, animated: false) // animated: false로 즉시 이동
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
        
        let contentInsets = UIEdgeInsets.zero
        
        UIView.animate(withDuration: animationDuration) {
            self.signUpView.scrollView.contentInset = contentInsets
            self.signUpView.scrollView.scrollIndicatorInsets = contentInsets
        }
        
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
            let isEnabled = self.viewModel.isSignUpButtonEnabled
            self.signUpView.signUpButton.isEnabled = isEnabled
            self.signUpView.signUpButton.alpha = isEnabled ? 1.0 : 0.5
        }
        
        // 회원가입 성공 바인딩
        viewModel.onSignUpSuccess = { [weak self] userEmail in
            guard let self = self else { return }
            
            // 인디케이터 로딩 종료 및 버튼 활성화
            self.activityIndicator.stopAnimating()
            self.signUpView.signUpButton.isEnabled = true
            self.signUpView.signUpButton.alpha = 1.0
            
            let alert = UIAlertController(title: "회원가입 성공", message: "환영합니다!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                let homeVC = HomeViewController(loggedInUserEmail: userEmail)
                
                if let windowScene = self.view.window?.windowScene, // 현재 뷰의 윈도우와 윈도우 씬을 얻음
                   let window = windowScene.windows.first { // 해당 윈도우 씬의 첫 번째 윈도우를 얻음
                    
                    if self.presentingViewController != nil { // 현재 VC가 모달로 띄워진 경우
                        self.dismiss(animated: true) { // 현재 VC를 dismiss
                            window.rootViewController = homeVC
                            window.makeKeyAndVisible()
                        }
                    } else { // 모달이 아닌 경우
                        window.rootViewController = homeVC
                        window.makeKeyAndVisible()
                    }
                }
            }))
            self.present(alert, animated: true)
        }
        
        // 회원가입 실패 바인딩
        viewModel.onSignUpFailure = { [weak self] errorType, message in
            guard let self = self else { return }

            self.activityIndicator.stopAnimating()
            self.signUpView.signUpButton.isEnabled = true
            self.signUpView.signUpButton.alpha = 1.0
            
            let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
            print("회원가입 실패: \(errorType) - \(message)")
        }
    }
}
