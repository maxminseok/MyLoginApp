//
//  TestViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit

class TestViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("--- UserRepository 테스트 시작 ---")
        
        let userRepository = UserRepository(context: CoreDataStack.shared.mainContext) // 주입받은 컨텍스트 사용
        
        // 테스트를 위해 사용할 사용자 데이터 정의 (매 실행마다 고유한 이메일을 사용하는 것이 좋습니다)
        let testEmail = "manual_test_\(UUID().uuidString.prefix(5))@example.com" // 매번 고유한 이메일 생성
        let newUser = UserDTO(email: testEmail, password: "password123", nickname: "manualTester")
        
        // --- 1. 사용자 생성 테스트 ---
        print("\n--- 1. 사용자 생성 시도 ---")
        do {
            try userRepository.createUser(userDTO: newUser)
            print("✅ 사용자 생성 성공: \(newUser.email)")
        } catch UserRepositoryError.userAlreadyExists {
            print("⚠️ 사용자 생성 실패: \(newUser.email)은 이미 존재합니다. (이전 테스트 잔여 데이터일 수 있음)")
        } catch {
            print("❌ 사용자 생성 중 알 수 없는 오류: \(error.localizedDescription)")
        }
        
        // --- 2. 생성된 사용자 조회 테스트 ---
        print("\n--- 2. 사용자 조회 시도 (생성된 사용자) ---")
        do {
            if let fetchedUser = try userRepository.fetchUser(email: newUser.email) {
                print("✅ 사용자 조회 성공: 이메일: \(fetchedUser.email), 닉네임: \(fetchedUser.nickname)")
            } else {
                print("❌ 사용자 조회 실패: \(newUser.email)을 찾을 수 없습니다. (생성 오류 확인 필요)")
            }
        } catch {
            print("❌ 사용자 조회 중 오류: \(error.localizedDescription)")
        }
        
        // --- 3. 이메일 중복 확인 테스트 ---
        print("\n--- 3. 이메일 중복 확인 시도 ---")
        do {
            if try userRepository.isEmailDuplicated(email: newUser.email) {
                print("✅ 이메일 중복 확인 성공: \(newUser.email)은 사용 중입니다.")
            } else {
                print("❌ 이메일 중복 확인 오류: \(newUser.email)이 사용 중이 아니라고 나옴. (로직 오류 확인 필요)")
            }
        } catch {
            print("❌ 이메일 중복 확인 중 오류: \(error.localizedDescription)")
        }
        
        // --- 4. 존재하지 않는 사용자 조회 테스트 ---
        print("\n--- 4. 존재하지 않는 사용자 조회 시도 ---")
        do {
            if let _ = try userRepository.fetchUser(email: "nonexistent@example.com") {
                print("❌ 오류: 존재하지 않는 사용자가 조회되었습니다.")
            } else {
                print("✅ 성공: 존재하지 않는 사용자(nonexistent@example.com)는 조회되지 않았습니다.")
            }
        } catch {
            print("❌ 존재하지 않는 사용자 조회 중 오류: \(error.localizedDescription)")
        }
        
        // --- 5. 사용자 삭제 테스트 ---
        print("\n--- 5. 사용자 삭제 시도 ---")
        do {
            try userRepository.deleteUser(email: newUser.email)
            print("✅ 사용자 삭제 성공: \(newUser.email)")
            
            // 삭제 후 다시 조회하여 삭제되었는지 확인
            if let _ = try userRepository.fetchUser(email: newUser.email) {
                print("❌ 오류: 사용자를 삭제했지만 여전히 조회됩니다.")
            } else {
                print("✅ 성공: 삭제 후 \(newUser.email)은 더 이상 조회되지 않습니다.")
            }
        } catch UserRepositoryError.userNotFound {
            print("⚠️ 사용자 삭제 실패: \(newUser.email)을 찾을 수 없습니다. (이미 삭제되었거나 생성 오류)")
        } catch {
            print("❌ 사용자 삭제 중 알 수 없는 오류: \(error.localizedDescription)")
        }
        
        print("\n--- UserRepository 테스트 종료 ---")    }
}
