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
    }
    
    func checkPassword() {
        if signUpView.pwTextField.text != signUpView.checkPwTextField.text {
            signUpView.checkPwAlertLabel.text = "비밀번호가 일치하지 않습니다."
            signUpView.checkPwAlertLabel.isHidden = false
            signUpView.checkPwUnderlineView.backgroundColor = .red
        } else {
            signUpView.checkPwAlertLabel.text = ""
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
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == signUpView.checkPwTextField {
            checkPassword()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
