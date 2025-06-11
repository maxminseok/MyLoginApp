//
//  StartView.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit
import SnapKit

class StartView: UIView {
    
    // MARK: - UI 컴포넌트 선언
    
    // Login 라벨
    private let loginLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Login"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    // 이메일 뷰
    private let emailView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    // 이메일 텍스트필드
    var emailTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Email"
        textField.textColor = .black
        textField.clearButtonMode = .always
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        return textField
    }()
    
    // 비밀번호 뷰
    private let pwView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = .systemGray5
        view.layer.cornerRadius = 8
        return view
    }()
    
    // 비밀번호 텍스트필드
    var pwTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textAlignment = .left
        textField.textColor = .black
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        return textField
    }()
    
    // 로그인 버튼
    let loginButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()
    
    // MARK: - 초기화
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI 레이아웃 메서드
    
    private func setupUI() {
        backgroundColor = .white
        
        emailView.addSubview(emailTextField)
        pwView.addSubview(pwTextField)
        [
            loginLabel,
            emailView,
            pwView,
            loginButton
        ].forEach { addSubview($0) }
        
        loginLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(160)
            $0.height.equalTo(50)
            $0.leading.equalToSuperview().offset(36)
            $0.width.equalTo(120)
        }
        
        emailView.snp.makeConstraints {
            $0.top.equalTo(loginLabel.snp.bottom).offset(36)
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.height.equalTo(50)
        }
        
        emailTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        pwView.snp.makeConstraints {
            $0.top.equalTo(emailView.snp.bottom).offset(20)
            $0.leading.width.height.equalTo(emailView)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwView.snp.bottom).offset(60)
            $0.leading.width.height.equalTo(emailView)
        }
    }
}

//extension StartView {
//    // MARK: - UI 접근 메서드
//    func setTextFieldDelegate(emailDelegate: UITextFieldDelegate, pwDelegate: UITextFieldDelegate) {
//        emailTextField.delegate = emailDelegate
//        pwTextField.delegate = pwDelegate
//    }
//
//    func dismissKeyboard() {
//        emailTextField.resignFirstResponder()
//        pwTextField.resignFirstResponder()
//    }
//
//    func setLoginButtonAction(target: Any, selector: Selector) {
//        loginButton.addTarget(target, action: selector, for: .touchUpInside)
//    }
//
//    func setReturnKeyType(emailType: UIReturnKeyType, pwType: UIReturnKeyType) {
//        emailTextField.returnKeyType = emailType
//        pwTextField.returnKeyType = pwType
//    }
//
//    func getNumberOfCharacter(textFieldName: String) -> Int? {
//
//    }
//
//}
