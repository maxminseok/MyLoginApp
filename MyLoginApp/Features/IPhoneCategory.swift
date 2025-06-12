//
//  IPhoneCategory.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/12/25.
//

import UIKit

enum IPhoneCategory {
    case se
    case normal
    case max
}

extension UIScreen {
    static var isiPhonePlus: Bool {
        main.bounds.height > 900
    }

    static var isiPhoneSE: Bool {
        main.bounds.height < 700
    }

    static var isiPhoneMini: Bool {
        main.bounds.height < 820
    }

    static var iPhoneCategory: IPhoneCategory {
        switch main.bounds.height {
        case 900..<CGFloat.greatestFiniteMagnitude: .max
        case 0..<700: .se
        default: .normal
        }
    }
}
