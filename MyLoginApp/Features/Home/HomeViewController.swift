//
//  HomeViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private var viewModel: HomeViewModel!

    let loggedInUserEmail: String?
    
    // MARK: - 초기화
    
    init(loggedInUserEmail: String) {
        self.loggedInUserEmail = loggedInUserEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(homeView)
        homeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        viewModel = HomeViewModel(userService: UserService(), currentUserEmail: self.loggedInUserEmail)
        
        setupActions()
        bindViewModel()
        
        // 뷰 로드 시 환영 메시지 로드 요청
        viewModel.loadWelcomeMessage()
    }
}

// MARK: - 버튼 설정

extension HomeViewController {
    // 로그아웃, 회원탈퇴 버튼 액션 설정
    private func setupActions() {
        homeView.logOutButton.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        homeView.deleteAccountButton.addTarget(self, action: #selector(deleteAccountButtonTapped), for: .touchUpInside)
    }

    // 로그아웃 버튼 동작 처리
    @objc private func logoutButtonTapped() {
        viewModel.logoutButtonTapped()
    }
    
    // 회원탈퇴 버튼 동작 처리
    @objc private func deleteAccountButtonTapped() {
        viewModel.deleteAccountButtonTapped()
    }
}

// MARK: - 바인딩

extension HomeViewController {
    private func bindViewModel() {
        // MARK: - 환영 메시지 업데이트 바인딩
        viewModel.onWelcomeMessageUpdated = { [weak self] message in
            guard let self = self else { return }
            self.homeView.welecomeLabel.text = message
        }
        
        // MARK: - 로그아웃 알림 요청 바인딩
        viewModel.onShowLogoutAlert = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.confirmLogout()
            }))
            self.present(alert, animated: true)
        }
        
        // MARK: - 회원 탈퇴 알림 요청 바인딩
        viewModel.onShowDeleteAccountAlert = { [weak self] in
            guard let self = self else { return }
            let alert = UIAlertController(title: "회원 탈퇴", message: "회원에서 탈퇴하시겠습니까?\n즉시 계정 정보가 삭제됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "취소", style: .cancel))
            alert.addAction(UIAlertAction(title: "확인", style: .destructive, handler: { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.confirmDeleteAccount()
            }))
            self.present(alert, animated: true)
        }
        
        // MARK: - 시작 화면으로 전환 요청 바인딩
        viewModel.onNavigateToStartView = { [weak self] in
            guard let self = self else { return }
            
            if let windowScene = self.view.window?.windowScene, // 현재 뷰가 속한 윈도우 씬을 가져옴
               let window = windowScene.windows.first { // 해당 윈도우 씬의 첫 번째 윈도우를 가져옴
                
                // StartViewController 인스턴스 생성
                let startVC = StartViewController()
                
                // 메인 스레드에서 UI 변경을 보장
                DispatchQueue.main.async {
                    window.rootViewController = startVC // 앱의 루트 뷰 컨트롤러를 StartViewController로 변경
                    window.makeKeyAndVisible() // 윈도우를 다시 보이게 함
                    
                    // 전환 시 애니메이션 효과 추가
                    UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
                }
            } else {
                // 윈도우를 찾을 수 없는 예외 상황
                print("윈도우를 찾을 수 없는 예외 상황..")
            }
        }
        
        // MARK: - 오류 발생 시 알림 바인딩
        viewModel.onError = { [weak self] errorType, message in
            guard let self = self else { return }
            print("오류 발생: \(errorType), 메시지: \(message)")
            let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            self.present(alert, animated: true)
        }
    }
}
