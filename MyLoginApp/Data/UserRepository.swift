//
//  UserRepository.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import Foundation
import CoreData

enum UserRepositoryError: Error {
    case userAlreadyExists
    case userNotFound
    case saveFailed(Error)
    case fetchFailed(Error)
}

final class UserRepository {
    
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.context = context
    }
    
    // MARK: - Create
    func createUser(userDTO: UserDTO) throws {
        // 이메일 중복 확인
        if (try? fetchUser(email: userDTO.email)) != nil {
            throw UserRepositoryError.userAlreadyExists
        }
        
        // CoreData User 엔티티 객체 생성
        let user = User(context: context)
        user.email = userDTO.email
        user.password = userDTO.password
        user.nickname = userDTO.nickname
        
        do {
            try context.save()
        } catch let error as NSError {
            // CoreData 고유성 제약조건 오류 처리
            if error.code == NSValidationRelationshipLacksMinimumCountError {
                throw UserRepositoryError.userAlreadyExists
            }
            throw UserRepositoryError.saveFailed(error)
        }
    }
    
    // MARK: - Read
    func fetchUser(email: String) throws -> UserDTO? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        fetchRequest.fetchLimit = 1 // 이메일은 고유하므로 1개만 가져오도록 설정
        
        do {
            let result = try context.fetch(fetchRequest)
            if let user = result.first {
                return UserDTO(
                    email: user.email ?? "",
                    password: user.password ?? "",
                    nickname: user.nickname ?? ""
                )
            }
            return nil // 해당 이메일의 사용자를 찾지 못할 경우
        } catch {
            throw UserRepositoryError.fetchFailed(error)
        }
    }
    
    // MARK: - delete
    func deleteUser(email: String) throws {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let result = try context.fetch(fetchRequest)
            if let userToDelete = result.first {
                context.delete(userToDelete)
                try context.save()
            } else {
                throw UserRepositoryError.userNotFound
            }
        } catch {
            throw UserRepositoryError.saveFailed(error)
        }
    }
}
