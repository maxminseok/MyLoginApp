//
//  SignUpView.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit
import SnapKit

final class SignUpView: UIView {
    
    var emailUnderlineView: UIView!
    var pwUnderlineView: UIView!
    var checkPwUnderlineView: UIView!
    var nickNameUnderlineView: UIView!
    
    // Sign UP 라벨
    private let signUpLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "Sign Up"
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - 이메일 UI
    
    // 이메일 스택뷰
    private let emailStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()

    // 이메일 라벨
    private let emailLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "아이디(이메일)"
        label.font = .systemFont(ofSize: 16)
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.blue.cgColor
        return label
    }()

    // 이메일 텍스트필드
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일 주소"
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .gray
        textField.clearButtonMode = .always
        textField.keyboardType = .emailAddress
        textField.autocapitalizationType = .none
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        textField.returnKeyType = .next
        return textField
    }()
    
    // 이메일 조건 경고 라벨
    var emailAlertLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    // MARK: - 비밀번호 UI

    // 비밀번호 스택뷰
    private let pwStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()

    // 비밀번호 라벨
    private let pwLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "비밀번호"
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // 비밀번호 텍스트필드
    var pwTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "비밀번호"
        textField.textColor = .black
        textField.textAlignment = .left
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        return textField
    }()
    
    // 비밀번호 조건 경고 라벨
    var pwAlertLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    // MARK: - 비밀번호 확인 UI

    // 비밀번호 확인 스택뷰
    private let checkPwStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()

    // 비밀번호 확인 라벨
    private let checkPwLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "비밀번호 확인"
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // 비밀번호 확인 텍스트필드
    var checkPwTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "비밀번호 확인"
        textField.textColor = .black
        textField.textAlignment = .left
        textField.clearButtonMode = .always
        textField.isSecureTextEntry = true
        textField.returnKeyType = .next
        return textField
    }()
    
    // 비밀번호 조건 경고 라벨
    var checkPwAlertLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    // MARK: - 닉네임 UI
    
    // 닉네임 스택뷰
    private let nickNameStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .fill
        return stackView
    }()

    // 닉네임 라벨
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // 닉네임 텍스트필드
    var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.font = .systemFont(ofSize: 14)
        textField.textColor = .gray
        textField.clearButtonMode = .always
        textField.returnKeyType = .done
        return textField
    }()
    
    // 닉네임 조건 경고 라벨
    var nickNameAlertLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 14)
        label.textColor = .red
        label.isHidden = true
        return label
    }()
    
    // MARK: - 회원가입 버튼 UI

    // 회원가입 버튼
    var signUpButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        button.setTitle("회원가입", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .boldSystemFont(ofSize: 20)
        return button
    }()

    // MARK: - 초기화

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupUI()
        setUnderline()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .white

        // MARK: - add view

        // 이메일 뷰에 추가
        [
            emailLabel,
            emailTextField,
            emailAlertLabel
        ].forEach { emailStackView.addArrangedSubview($0) }

        // 비밀번호 뷰에 추가
        [
            pwLabel,
            pwTextField,
            pwAlertLabel
        ].forEach { pwStackView.addArrangedSubview($0) }

        // 비밀번호 확인 뷰(라벨 + 텍스트필드) 추가
        [
            checkPwLabel,
            checkPwTextField,
            checkPwAlertLabel
        ].forEach { checkPwStackView.addArrangedSubview($0) }
        
        // 닉네임 뷰(라벨 + 텍스트필드) 추가
        [
            nickNameLabel,
            nickNameTextField,
            nickNameAlertLabel
        ].forEach { nickNameStackView.addArrangedSubview($0) }

        // 뷰에 추가
        [
            signUpLabel,
            emailStackView,
            pwStackView,
            checkPwStackView,
            nickNameStackView,
            signUpButton
        ].forEach { addSubview($0) }

        // MARK: - layout
        
        // sign up 라벨 Layout
        signUpLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(80)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(72)
        }
        
        // MARK: - 이메일 레이아웃

        // 이메일 스택뷰 Layout
        emailStackView.snp.makeConstraints {
            $0.top.equalTo(signUpLabel.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        // 이메일 라벨 Layout
        emailLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        // 이메일 텍스트필드 Layout
        emailTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        // 이메일 확인 라벨 Layout
        emailAlertLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        // MARK: - 비밀번호 레이아웃

        // 비밀번호 스택뷰 Layout
        pwStackView.snp.makeConstraints {
            $0.top.equalTo(emailStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        // 비밀번호 라벨 Layout
        pwLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        // 비밀번호 텍스트필드 Layout
        pwTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        // 비밀번호 조건 라벨 layout
        pwAlertLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        // MARK: - 비밀번호 확인 레이아웃

        // 비밀번호 확인 스택뷰 Layout
        checkPwStackView.snp.makeConstraints {
            $0.top.equalTo(pwStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
        }

        // 비밀번호 확인 라벨 Layout
        checkPwLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        // 비밀번호 동일한 상태 확인 라벨 Layout
        checkPwLabel.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        // 비밀번호 확인 텍스트필드 Layout
        checkPwTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        checkPwAlertLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        // MARK: - 닉네임 레이아웃
        
        // 닉네임 스택뷰 Layout
        nickNameStackView.snp.makeConstraints {
            $0.top.equalTo(checkPwStackView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(74)
        }

        // 닉네임 라벨 Layout
        nickNameLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }

        // 닉네임 텍스트필드 Layout
        nickNameTextField.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        
        nickNameAlertLabel.snp.makeConstraints {
            $0.height.equalTo(20)
        }
        
        // MARK: - 회원가입 버튼 레이아웃

        // 회원가입 버튼 Layout
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(nickNameStackView.snp.bottom).offset(160)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
    }
}

// MARK: - 밑줄 생성

extension SignUpView {

    // 텍스트필드 하단에 밑줄 생성 메서드
    private func addUnderlineView(to textField: UITextField) -> UIView {
        let underlineView = UIView()
        underlineView.backgroundColor = .lightGray
        textField.addSubview(underlineView)

        underlineView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        return underlineView
    }

    // 텍스트필드에 밑줄을 추가
    private func setUnderline() {
        emailUnderlineView = addUnderlineView(to: emailTextField)
        pwUnderlineView = addUnderlineView(to: pwTextField)
        checkPwUnderlineView = addUnderlineView(to: checkPwTextField)
        nickNameUnderlineView = addUnderlineView(to: nickNameTextField)
    }
}
