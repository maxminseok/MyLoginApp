//
//  StartViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/9/25.
//

import UIKit

class StartViewController: UIViewController {
    
    private let startView = StartView()
    
    override func viewWillAppear(_ animated: Bool) {
        view = startView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldSetup()
    }
}

extension StartViewController: UITextFieldDelegate {
    private func textFieldSetup() {
        startView.emailTextField.delegate = self
        startView.pwTextField.delegate = self
        
        startView.emailTextField.returnKeyType = .done
        startView.pwTextField.returnKeyType = .done
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if startView.emailTextField.text != "", startView.pwTextField.text != "" {
            startView.pwTextField.resignFirstResponder()
            return true
        }
        else if startView.emailTextField.text != "" {
            startView.pwTextField.becomeFirstResponder()
            return true
        }
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
