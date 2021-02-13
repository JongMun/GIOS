//
//  ResetPwViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/12.
//

import UIKit
import Firebase

class ResetPwViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var resetPWButton: UIButton!
    @IBOutlet weak var returnMenuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDisplayUI()
        buttonEvent()
    }
    
    func setDisplayUI() {
        self.titleLabel.text = "비밀번호 초기화"
        self.emailField.placeholder = "Email을 입력해주세요."
        self.resetPWButton.setTitle("비밀번호 확인", for: .normal)
        self.returnMenuButton.setTitle("돌아가기", for: .normal)
    }
    
    func buttonEvent() {
        self.resetPWButton.addTarget(self, action: #selector(resetPWButtonAction), for: .touchUpInside)
        self.returnMenuButton.addTarget(self, action: #selector(returnMenuButtonAction), for: .touchUpInside)
    }
}

extension ResetPwViewController {
    @objc func resetPWButtonAction(_ sender: UIButton) {
        guard let email: String = self.emailField.text, email.isEmpty == false else {
            self.view.messageShow(self, message: "이메일란을 확인해주십시오.")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: email) {
            ( error ) in
            if let error = error {
                print("sendPasswordReset : \(error)")
                return
            }
            
            self.view.messageShow(self, message: "비밀번호 재설정 이메일이 발송되었습니다.")
            print("변경된 비밀번호가 이메일로 보내짐.")
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
