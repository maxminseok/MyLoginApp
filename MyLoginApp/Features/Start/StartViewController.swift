//
//  StartViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/9/25.
//

import UIKit
import SnapKit

class StartViewController: UIViewController {
    
    private let startView = StartView()
    private let viewModel = StartViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(startView)
        startView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        textFieldSetup()
        bindings()
        setupActions()
        
        print("[StartViewController] isLoggedIn: \(LoginSessionManager.isLoggedIn)")
        print("[StartViewController] lastLoginEmail: \(LoginSessionManager.lastLoginEmail ?? "이메일 없음")")
    }
    
    // 로그인 버튼 동작 설정
    private func setupActions() {
        startView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    // 로그인 버튼 동작 처리
    @objc private func loginButtonTapped() {
        viewModel.inputEmail = startView.emailTextField.text ?? ""
        viewModel.inputPassword = startView.pwTextField.text ?? ""
        viewModel.loginButtonTapped()
    }
}

// MARK: - 텍스트 필드 입력 처리

extension StartViewController: UITextFieldDelegate {
    private func textFieldSetup() {
        startView.emailTextField.delegate = self
        startView.pwTextField.delegate = self
        
        startView.emailTextField.returnKeyType = .done
        startView.pwTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if startView.emailTextField.text != "", startView.pwTextField.text != "" {
            startView.pwTextField.resignFirstResponder()
            return true
        }
        else if startView.emailTextField.text != "" {
            startView.pwTextField.becomeFirstResponder()
            return true
        }
        return false
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

// MARK: - 바인딩

extension StartViewController {
    private func bindings() {
        // 로그인 성공 시 로그인 성공 화면으로 이동
        viewModel.onLoginSuccess = { [weak self] email in
            let homeViewController = HomeViewController(loggedInUserEmail: email)
            self?.present(homeViewController, animated: true)
        }
        
        // 비회원일 시 회원가입 화면으로 이동
        viewModel.onNavigateToSignUp = { [weak self] in
            let signUpViewController = SignUpViewController()
            self?.present(signUpViewController, animated: true)
        }
        
        // 로그인 실패 시 alert 동작
        viewModel.onLoginFailure = { [weak self] reason in
            guard let self = self else { return }
            let alert: UIAlertController

            switch reason {
            // 필드 입력을 안 했을 때
            case .emptyFields:
                alert = UIAlertController(title: "로그인 실패", message: "이메일과 비밀번호를 모두 입력해 주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))

            // 비회원일 때
            case .userNotFound:
                alert = UIAlertController(title: "로그인 실패", message: "존재하지 않는 사용자입니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "회원 가입", style: .default, handler: { _ in
                    self.viewModel.onNavigateToSignUp?()
                }))

            // 비밀번호를 틀렸을 때
            case .wrongPassword:
                alert = UIAlertController(title: "로그인 실패", message: "비밀번호가 틀렸습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
            
            // 에러 발생했을 때
            case .serviceError:
                alert = UIAlertController(title: "로그인 실패", message: "사용자 정보를 불러오는데 실패했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
            }
            
            self.present(alert, animated: true)
        }
    }
}
