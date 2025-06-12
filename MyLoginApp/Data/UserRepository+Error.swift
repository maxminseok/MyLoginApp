//
//  UserRepository+Error.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
//

import Foundation

enum UserRepositoryError: Error {
    case userAlreadyExists
    case userNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
}
