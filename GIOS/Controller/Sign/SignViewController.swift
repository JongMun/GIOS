//
//  SignViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit
import Firebase

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
        buttonEvent()
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
    
    func buttonEvent() {
        self.signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)
        self.snsSignInButton.addTarget(self, action: #selector(snsSignInButtonAction), for: .touchUpInside)
        self.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        self.resetPWButton.addTarget(self, action: #selector(resetPWButtonAction), for: .touchUpInside)
        self.returnMenuButton.addTarget(self, action: #selector(returnMenuButtonAction), for: .touchUpInside)
    }
}

extension SignViewController {
    @objc func signInButtonAction(_ sender: UIButton) {
        guard let email = self.emailField.text, email.isEmpty == false else {
            self.view.messageShow(self, message: "이메일을 확인해주세요.")
            self.emailField.becomeFirstResponder()
            return
        }
        
        guard let passwd = self.passwdField.text, passwd.isEmpty == false else {
            self.passwdField.becomeFirstResponder()
            self.view.messageShow(self, message: "비밀번호를 확인해주세요.")
            return
        }
        
        // Firebase Email Sign In
        Auth.auth().signIn(withEmail: email, password: passwd) {
            ( result, error ) in
            if let error = error {
                self.view.messageShow(self, message: "로그인에 실패하였습니다.")
                print("Error : \(error.localizedDescription)")
                return
            }
            self.view.messageShow(self, message: "로그인에 성공하였습니다.")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                do {
                    try Auth.auth().signOut()
                } catch let error as NSError {
                    print("Sign Out Error : \(error)")
                }
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @objc func snsSignInButtonAction(_ sender: UIButton) {
        pageMovement("SNSSignInViewController")
    }
    
    @objc func signUpButtonAction(_ sender: UIButton) {
        pageMovement("SignUpViewController")
    }
    
    @objc func resetPWButtonAction(_ sender: UIButton) {
        pageMovement("ResetPwViewController")
    }
    
    @objc func returnMenuButtonAction(_ sender: UIButton) {
        print("Dismiss")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func pageMovement(_ storyboardId: String) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: storyboardId) else {
            print("Undefined Storyboard ID")
            return
        }
        self.emailField.text = ""
        self.emailField.text = ""
        print("Page : \(storyboardId)")
        self.present(vc, animated: true, completion: nil)
    }
    
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
