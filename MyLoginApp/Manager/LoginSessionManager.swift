//
//  LoginSessionManager.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
//

import Foundation

enum LoginSessionManager {
    private static let loginKey = "isLoggedIn"
    private static let emailKey = "lastLoginEmail"
    
    static var isLoggedIn: Bool {
        return UserDefaults.standard.bool(forKey: loginKey)
    }
    
    static var lastLoginEmail: String? {
        return UserDefaults.standard.string(forKey: emailKey)
    }
    
    static func logIn(email: String) {
        UserDefaults.standard.set(true, forKey: loginKey)
        UserDefaults.standard.set(email, forKey: emailKey)
    }
    
    static func logOut() {
        UserDefaults.standard.set(false, forKey: loginKey)
        UserDefaults.standard.removeObject(forKey: emailKey)
    }
}
