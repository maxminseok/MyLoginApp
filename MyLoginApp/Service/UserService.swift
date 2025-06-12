//
//  UserService.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import Foundation

final class UserService {
    
    private let userRepository = UserRepository()

    // 회원가입 요청
    func registerUser(_ user: UserDTO) throws {
        // 중복 검사
        if let _ = try getUser(email: user.email) {
            throw UserServiceError.duplicateEmail
        }
        // 가입 시도
        do {
            try userRepository.createUser(userDTO: user)
        } catch UserRepositoryError.userAlreadyExists {
            throw UserServiceError.duplicateEmail
        } catch {
            throw UserServiceError.registrationFailed(message: error.localizedDescription)
        }
    }

    // 유저 조회
    func getUser(email: String) throws -> UserDTO? {
        do {
            return try userRepository.fetchUser(email: email)
        } catch UserRepositoryError.userNotFound {
            throw UserServiceError.userNotFound
        } catch {
            throw UserServiceError.userLoadFailed
        }
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
