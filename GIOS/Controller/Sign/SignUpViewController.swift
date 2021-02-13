//
//  SignUpViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/12.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    private var userEmail: String?

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwdField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleSignUpButton: UIButton!
    @IBOutlet weak var appleSignUpButton: UIButton!
    @IBOutlet weak var returnMenuButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDisplayUI()
        buttonEvent()
    }
    
    func setDisplayUI() {
        self.titleLabel.text = "회원가입"
        self.emailField.placeholder = "Email을 입력해주세요."
        self.passwdField.placeholder = "비밀번호를 입력해주세요."
        self.signUpButton.setTitle("회원가입", for: .normal)
        self.returnMenuButton.setTitle("돌아가기", for: .normal)
    }
    
    func buttonEvent() {
        self.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        self.returnMenuButton.addTarget(self, action: #selector(returnMenuButtonAction), for: .touchUpInside)
    }
}

extension SignUpViewController {
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
        
        // Firebase Email Sign Up
        Auth.auth().createUser(withEmail: email, password: passwd) {
            ( result, error ) in
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            self.view.messageShow(self, message: "가입이 완료되었습니다.")
            
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
    
    @objc func signUpButtonAction(_ sender: UIButton) {
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
        
        Auth.auth().createUser(withEmail: email, password: passwd) {
            ( result, error ) in
            if let error = error {
                print("Create User Error : \(error.localizedDescription)")
                return
            }
            self.view.messageShow(self, message: "가입이 완료되었습니다.")
            
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
    
    @objc func returnMenuButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
