//
//  HomeViewModel.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/11/25.
//

import Foundation

enum HomeViewModelError: Error {
    case userLoadFailed
    case logoutFailed
    case deletionFailed(message: String?)
    
    var message: String {
        switch self {
        case .userLoadFailed: return "사용자 정보를 불러오는데 실패했습니다."
        case .logoutFailed: return "로그아웃에 실패했습니다."
        case .deletionFailed(let msg): return msg ?? "회원 탈퇴에 실패했습니다. 다시 시도해주세요."
        }
    }
}

final class HomeViewModel {
    
    private let userService: UserService
    
    let currentUserEmail: String?
    
    // MARK: - Output
    
    // 뷰에 표시될 환영 메시지
    var onWelcomeMessageUpdated: ((String) -> Void)?
    
    // 로그아웃 확인 알림 요청 (뷰컨트롤러가 알림을 띄우도록)
    var onShowLogoutAlert: UpdateHandler?
    
    // 회원 탈퇴 확인 알림 요청
    var onShowDeleteAccountAlert: UpdateHandler?
    
    // 화면 전환 요청 (로그인 화면으로 돌아가기)
    var onNavigateToStartView: UpdateHandler?
    
    // 오류 발생 시 알림 (alert 메시지 표시)
    var onError: ((HomeViewModelError, String) -> Void)?
    
    // MARK: - 초기화
    
    init(userService: UserService = UserService(), currentUserEmail: String?) {
        self.userService = userService
        self.currentUserEmail = currentUserEmail
    }
    
    // MARK: - Input
    
    func loadWelcomeMessage() {
        guard let email = currentUserEmail else {
            onError?(.userLoadFailed, HomeViewModelError.userLoadFailed.message)
            return
        }
        do {
            if let user = try userService.getUser(email: email) {
                onWelcomeMessageUpdated?("\(user.nickname) 님 환영합니다!")
            } else {
                // userService.getUser가 nil을 반환한 경우 (사용자를 찾을 수 없음)
                onError?(.userLoadFailed, HomeViewModelError.userLoadFailed.message)
            }
        } catch let error as UserServiceError {
            onError?(.userLoadFailed, error.message ?? "사용자 정보를 불러오는데 실패했습니다.")
        } catch {
            onError?(.userLoadFailed, HomeViewModelError.userLoadFailed.message)
        }
    }
    
    // 로그아웃 버튼 탭 시 호출
    func logoutButtonTapped() {
        onShowLogoutAlert?()
    }
    
    // 로그아웃 확인 알림에서 '확인' 버튼 클릭 시 호출
    func confirmLogout() {
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        onNavigateToStartView?() // StartView로 이동 요청
    }
    
    // 회원 탈퇴 버튼 탭 시 호출
    func deleteAccountButtonTapped() {
        onShowDeleteAccountAlert?()
    }
    
    // 회원 탈퇴 확인 알림에서 '확인' 버튼 클릭 시 호출
    func confirmDeleteAccount() {
        guard let email = currentUserEmail else {
            onError?(.deletionFailed(message: "삭제할 사용자 정보가 없습니다."), HomeViewModelError.deletionFailed(message: nil).message)
            return
        }
        do {
            try userService.deleteUser(email: email)
            UserDefaults.standard.set(false, forKey: "isLoggedIn")
            onNavigateToStartView?()
        } catch let error as UserServiceError {
            onError?(.deletionFailed(message: error.message), error.message ?? "회원 탈퇴에 실패했습니다.")
        } catch {
            onError?(.deletionFailed(message: nil), HomeViewModelError.deletionFailed(message: nil).message)
        }
    }
}
