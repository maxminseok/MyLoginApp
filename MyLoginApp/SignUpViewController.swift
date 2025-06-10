//
//  SignUpViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit

class SignUpViewController: UIViewController {
    
    private let signUpView = SignUpView()
    
    override func viewWillAppear(_ animated: Bool) {
        view = signUpView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
