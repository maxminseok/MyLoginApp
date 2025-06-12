//
//  LoginFailureReason.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
//

import Foundation

enum LoginFailureReason {
    case emptyFields
    case userNotFound
    case wrongPassword
    case serviceError
    
    var message: String {
        switch self {
        case .emptyFields: return "이메일과 비밀번호를 모두 입력해주세요."
        case .userNotFound: return "존재하지 않는 사용자입니다."
        case .wrongPassword: return "비밀번호가 틀렸습니다."
        case .serviceError: return "사용자 정보를 불러오는데 실패했습니다."
        }
    }
}
