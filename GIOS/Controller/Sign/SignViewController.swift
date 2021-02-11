//
//  SignViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit


class SignViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var snsSignInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var resetPWButton: UIButton!
    @IBOutlet weak var returnMenuButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDisplayUI()
    }
    
    func setDisplayUI() {
        self.titleLabel.text = "로그인/로그아웃/가입"
        self.emailField.placeholder = "Email을 입력해주세요."
        self.passwdField.placeholder = "비밀번호를 입력해주세요."
        self.signInButton.setTitle("로그인", for: .normal)
        self.snsSignInButton.setTitle("SNS 로그인", for: .normal)
        self.signUpButton.setTitle("회원가입", for: .normal)
        self.resetPWButton.setTitle("비밀번호 찾기", for: .normal)
        self.returnMenuButton.setTitle("돌아가기", for: .normal)
    }
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        
    }
    
    @IBAction func returnMenuButtonAction(_ sender: UIButton) {
        
    }
}

extension SignViewController {
    private func pageMovement(_ storyboardId: String) {
        
    }
}
