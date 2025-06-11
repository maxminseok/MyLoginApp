//
//  HomeView.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit
import SnapKit

final class HomeView: UIView {
    
    private let homeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = "로그인 성공!"
        label.textColor = .black
        label.font = .systemFont(ofSize: 36, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    var welecomeLabel: UILabel = {
        let label: UILabel = UILabel()
        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .left
        return label
    }()
    
    let logOutButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    let deleteAccountButton: UIButton = {
        let button: UIButton = UIButton()
        button.backgroundColor = .black
        button.setTitle("회원 탈퇴", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.gray, for: .highlighted)
        button.layer.cornerRadius = 14
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
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
        
        [
            homeLabel,
            welecomeLabel,
            logOutButton,
            deleteAccountButton
        ].forEach { addSubview($0) }
        
        homeLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(120)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().inset(36)
        }
        
        welecomeLabel.snp.makeConstraints {
            $0.top.equalTo(homeLabel.snp.bottom).offset(36)
            $0.height.equalTo(50)
            $0.leading.trailing.equalToSuperview().offset(36)
        }
        
        logOutButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.height.equalTo(50)
        }
        
        deleteAccountButton.snp.makeConstraints {
            $0.top.equalTo(logOutButton.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview().inset(36)
            $0.height.equalTo(50)
        }
        
    }
}
