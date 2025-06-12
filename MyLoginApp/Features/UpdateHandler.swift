//
//  UpdateHandler.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
//

import Foundation

// ViewModel의 상태 변화를 View로 전달하기 위한 클로저 타입 정의
// 뷰모델의 프로퍼티가 변경될 때마다 호출될 클로저
typealias UpdateHandler = () -> Void
