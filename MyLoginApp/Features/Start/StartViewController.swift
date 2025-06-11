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
    }
    
    private func setupActions() {
        startView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func loginButtonTapped() {
        viewModel.inputEmail = startView.emailTextField.text ?? ""
        viewModel.inputPassword = startView.pwTextField.text ?? ""
        viewModel.loginButtonTapped()
    }
}

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
        viewModel.onLoginSuccess = { [weak self] email in
            let homeViewController = HomeViewController(loggedInUserEmail: email)
            self?.present(homeViewController, animated: true)
        }
        
        viewModel.onNavigateToSignUp = { [weak self] in
            let signUpViewController = SignUpViewController()
            self?.present(signUpViewController, animated: true)
        }
        
        viewModel.onLoginFailure = { [weak self] reason in
            guard let self = self else { return }
            let alert: UIAlertController

            switch reason {
            case .emptyFields:
                alert = UIAlertController(title: "로그인 실패", message: "이메일과 비밀번호를 모두 입력해 주세요.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))

            case .userNotFound:
                alert = UIAlertController(title: "로그인 실패", message: "존재하지 않는 사용자입니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "취소", style: .cancel))
                alert.addAction(UIAlertAction(title: "회원 가입", style: .default, handler: { _ in
                    self.viewModel.onNavigateToSignUp?()
                }))

            case .wrongPassword:
                alert = UIAlertController(title: "로그인 실패", message: "비밀번호가 틀렸습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))

            case .serviceError:
                alert = UIAlertController(title: "로그인 실패", message: "사용자 정보를 불러오는데 실패했습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default))
            }

            self.present(alert, animated: true)
        }
    }
}
