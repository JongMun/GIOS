//
//  SignUpViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/12.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn
import AuthenticationServices

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
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        setDisplayUI()
        buttonEvent()
    }
    
    func setDisplayUI() {
        self.titleLabel.text = "회원가입"
        self.emailField.placeholder = "Email을 입력해주세요."
        self.passwdField.placeholder = "비밀번호를 입력해주세요."
        self.signUpButton.setTitle("회원가입", for: .normal)
        self.googleSignUpButton.setTitle("구글로 회원가입", for: .normal)
        self.appleSignUpButton.setTitle("애플로 회원가입", for: .normal)
//        self.signUpButton.setTitle("회원가입", for: .normal)
//        self.resetPWButton.setTitle("비밀번호 찾기", for: .normal)
        self.returnMenuButton.setTitle("돌아가기", for: .normal)
        
//        self.view.addSubview(google)
//        self.google.topAnchor.constraint(equalTo: returnMenuButton.topAnchor, constant: 30)
//        
//        self.googleSignUpButton = A
    }
    
    func buttonEvent() {
        self.signUpButton.addTarget(self, action: #selector(signUpButtonAction), for: .touchUpInside)
        self.googleSignUpButton.addTarget(self, action: #selector(googleSignUpAction), for: .touchUpInside)
        self.appleSignUpButton.addTarget(self, action: #selector(appleSignUpAction), for: .touchUpInside)
        self.returnMenuButton.addTarget(self, action: #selector(returnMenuButtonAction), for: .touchUpInside)
//        self.resetPWButton.addTarget(self, action: #selector(resetPWButtonAction), for: .touchUpInside)
//        self.returnMenuButton.addTarget(self, action: #selector(returnMenuButtonAction), for: .touchUpInside)
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

    }
    
    @objc func googleSignUpAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        
        // Sign Out
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    @objc func appleSignUpAction(_ sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    @objc func returnMenuButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// Google Sign In
extension SignUpViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // 계정 연결 해제
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          print("\(error.localizedDescription)")
          return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) {
            (authResult, error) in
            if let error = error {
                print("Firebase Sign in error : \(error.localizedDescription)")
            } else {
                if let result = authResult {
                    self.userEmail = result.user.email
//                    print("UserEmail : \(result.user.email)")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// Apple Sign In
extension SignUpViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let tokenData = credential.identityToken, let tokenString = String(data: tokenData, encoding: .utf8) {
                let newCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: .none)
                
                Auth.auth().signIn(with: newCredential) {
                    ( result, error ) in
                    if let error = error {
                        print("Firebase Sign in error : \(error.localizedDescription)")
                    } else {
                        if let result = result {
                            self.userEmail = result.user.email
//                            print("UserEmail : \(result.user.email)")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
                print("Token Disabled")
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Error in Sign in width Apple  : \(error.localizedDescription)")
    }
    
    func getCredentialState(userid: String) {
        let provider = ASAuthorizationAppleIDProvider()
        provider.getCredentialState(forUserID: userid) {
            ( state, _ ) in
            switch state {
            case .authorized:
                print("Authorized")
                break
            case .revoked:
                print("Revoked")
                break
            case .notFound:
                print("NotFound")
                break
            default:
                print("Default")
                break
            }
        }
    }
}

