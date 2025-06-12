//
//  UserServiceError.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
//

import Foundation

enum UserServiceError: Error {
    case emailCheckFailed
    case duplicateEmail
    case registrationFailed(message: String?)
    case deletionFailed
    case userNotFound
    case userLoadFailed
    
    // 에러 메시지를 쉽게 가져오기 위한 연산 프로퍼티 추가
    var message: String? {
        switch self {
        case .duplicateEmail:
            return "이미 사용 중인 이메일입니다."
        case .registrationFailed(let msg):
            return msg ?? "회원가입에 실패했습니다. 다시 시도해주세요."
        case .deletionFailed:
            return "회원 탈퇴에 실패했습니다."
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .emailCheckFailed:
            return "중복 검사에 실패했습니다."
        case .userLoadFailed:
            return "사용자 정보를 불러오는데 실패했습니다."
        }
    }
}
