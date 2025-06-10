//
//  HomeViewController.swift
//  MyLoginApp
//
//  Created by 박민석 on 6/10/25.
//

import UIKit
import SnapKit

final class HomeViewController: UIViewController {
    
    private let homeView = HomeView()
    private let nickname: String = "철수"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(homeView)
        homeView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        homeView.welecomeLabel.text = "\(nickname) 님 환영합니다!"
    }
}
