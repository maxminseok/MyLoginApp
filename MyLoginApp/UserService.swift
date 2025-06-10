//
//  UserService.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import Foundation

enum UserServiceError: Error {
    case emailCheckFailed
    case duplicateEmail
    case registrationFailed(message: String?)
    case deletionFailed
    case userNotFound
    
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
        }
    }
}

final class UserService {
    
    private let userRepository = UserRepository()

    // 이메일 중복 확인
    func isEmailDuplicated(_ email: String) throws -> Bool {
        do {
            return try userRepository.isEmailDuplicated(email: email)
        } catch {
            throw UserServiceError.emailCheckFailed
        }
    }

    // 회원가입 요청
    func registerUser(_ user: UserDTO) throws {
        do {
            try userRepository.createUser(userDTO: user)
        } catch UserRepositoryError.userAlreadyExists {
            throw UserServiceError.duplicateEmail
        } catch {
            throw UserServiceError.registrationFailed(message: error.localizedDescription)
        }
    }

    // 유저 조회
    func getUser(email: String) -> UserDTO? {
        return try? userRepository.fetchUser(email: email)
    }

    // 회원 탈퇴
    func deleteUser(email: String) throws {
        do {
            try userRepository.deleteUser(email: email)
        } catch UserRepositoryError.userNotFound {
            throw UserServiceError.userNotFound
        } catch {
            throw UserServiceError.deletionFailed
        }
    }
}
