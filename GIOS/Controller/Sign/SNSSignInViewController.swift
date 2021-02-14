//
//  SNSSignViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/12.
//

import UIKit
import Firebase
// Google Login
import GoogleSignIn
// Apple Login
import AuthenticationServices
// Facebook Login
import FBSDKCoreKit
import FBSDKLoginKit

class SNSSignInViewController: UIViewController {
    
    fileprivate var userEmail: String?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var naverSignInButton: UIButton!
    @IBOutlet weak var returnMenuButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        
        setDisplayUI()
        buttonEvent()
    }
    
    func setDisplayUI() {
        self.titleLabel.text = "SNS 로그인"
        self.googleSignInButton.setTitle("구글로 로그인", for: .normal)
        self.appleSignInButton.setTitle("애플로 로그인", for: .normal)
        self.facebookSignInButton.setTitle("페이스북으로 로그인", for: .normal)
        self.naverSignInButton.setTitle("네이버로 로그인", for: .normal)
        self.returnMenuButton.setTitle("돌아가기", for: .normal)
    }
    
    func buttonEvent() {
        self.googleSignInButton.addTarget(self, action: #selector(googleSignInAction), for: .touchUpInside)
        self.appleSignInButton.addTarget(self, action: #selector(appleSignInAction), for: .touchUpInside)
        self.facebookSignInButton.addTarget(self, action: #selector(facebookSignInAction), for: .touchUpInside)
        self.returnMenuButton.addTarget(self, action: #selector(returnMenuButtonAction), for: .touchUpInside)
    }
}

extension SNSSignInViewController {
    @objc func googleSignInAction(_ sender: UIButton) {
        GIDSignIn.sharedInstance().signIn()
        
        // Sign Out
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    @objc func appleSignInAction(_ sender: UIButton) {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
    
    @objc func facebookSignInAction(_ sender: UIButton) {
        facebookSignIn()
    }
    
    @objc func returnMenuButtonAction(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            do {
                try Auth.auth().signOut()
            } catch let error as NSError {
                print("Sign Out Error : \(error)")
            }
            self.dismiss(animated: true, completion: nil)
        })
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // Keyboard Hiding When Other Field Tabbed
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

// Google Sign In
extension SNSSignInViewController: GIDSignInDelegate {
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
            ( user, error ) in
            if let error = error {
                print("Firebase Sign in error : \(error.localizedDescription)")
            } else {
                if let user = user {
                    self.userEmail = user.user.email
//                    print("UserEmail : \(result.user.email)")
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

// Apple Sign In
extension SNSSignInViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            if let tokenData = credential.identityToken, let tokenString = String(data: tokenData, encoding: .utf8) {
                let newCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: .none)
                
                Auth.auth().signIn(with: newCredential) {
                    ( user, error ) in
                    if let error = error {
                        print("Firebase Sign in error : \(error.localizedDescription)")
                    } else {
                        if let user = user {
                            self.userEmail = user.user.email
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

// Facebook Sign In
extension SNSSignInViewController {
    func facebookSignIn() {
        ApplicationDelegate.initializeSDK(nil)
        
        let manager = LoginManager()
        manager.logIn(permissions: ["email"], from: self) {
            ( result, error ) in
            if let error = error {
                print("Failed to FaceBook Login: \(error.localizedDescription)")
                return
            }
            
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential, completion: {
                ( user, error ) in
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    return
                } else {
                    if let email = user?.user.email {
                        self.userEmail = email
                    }

                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        manager.logOut()
    }
}

