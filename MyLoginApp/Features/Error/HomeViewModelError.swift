//
//  HomeViewModelError.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
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
