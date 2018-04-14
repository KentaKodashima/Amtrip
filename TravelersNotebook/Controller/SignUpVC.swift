//
//  SignUpVC.swift
//  Traveler's Notebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

class SignUpVC: UIViewController, UITextFieldDelegate, GIDSignInDelegate, GIDSignInUIDelegate {
  
  @IBOutlet weak var signUpEmail: UITextField!
  @IBOutlet weak var signUpFirstName: UITextField!
  @IBOutlet weak var signUpLastName: UITextField!
  @IBOutlet weak var signUpPassword: UITextField!
  @IBOutlet weak var FBLoginBtn: UIButton!
  
  private let signInSegue = "moveOnToTopPage"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Enable return key of UITextFields
    self.signUpFirstName.delegate = self
    self.signUpLastName.delegate = self
    self.signUpEmail.delegate = self
    self.signUpPassword.delegate = self
    
    GIDSignIn.sharedInstance().delegate = self
    GIDSignIn.sharedInstance().uiDelegate = self
  }
  
  /*
   Enable return key of UITextFields
  */
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    signUpFirstName.resignFirstResponder()
    signUpLastName.resignFirstResponder()
    signUpEmail.resignFirstResponder()
    signUpPassword.resignFirstResponder()
    return true
  }
  
  /*
   An IBAction to create a user and perform a a segue when user is varified.
  */
  @IBAction func signUp() {
    Auth.auth().createUser(withEmail: signUpEmail.text!, password: signUpPassword.text!) { (user, error) in
      if error != nil {
        if let errorCode = AuthErrorCode(rawValue: error!._code) {
          switch errorCode {
          case .weakPassword:
            print("Weak password")
          default:
            print("There's an error")
          }
        }
      }
      if user != nil {
        user?.sendEmailVerification() {
          error in
          print("User creation")
        }
        Auth.auth().signIn(
          withEmail: self.signUpEmail.text!,
          password: self.signUpPassword.text!
        )
        self.performSegue(withIdentifier: self.signInSegue, sender: nil)
      }
    }
  }
  
  /*
   Authentication with Facebook account
  */
  @IBAction func facebookLogin(sender: AnyObject) {
    let LoginManager = FBSDKLoginManager()
    LoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
      if let error = error {
        print("Failed to login: \(error.localizedDescription)")
        return
      }
      
      guard let accessToken = FBSDKAccessToken.current() else {
        print("Failed to get access token")
        return
      }
      
      let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
      
      // Perform login by calling Firebase APIs
      Auth.auth().signIn(with: credential, completion: { (user, error) in
        if let error = error {
          print("Login error: \(error.localizedDescription)")
          let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
          let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
          alertController.addAction(okayAction)
          self.present(alertController, animated: true, completion: nil)
          
          return
        }
        self.performSegue(withIdentifier: self.signInSegue, sender: nil)
      })
      
    }
  }
  
  /*
    Present a sign-in with Google window
   */
  @IBAction func googleSignIn(sender: AnyObject) {
    GIDSignIn.sharedInstance().signIn()
  }
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    print("Google Sing In didSignInForUser")
    if let error = error {
      print(error.localizedDescription)
      return
    }
    
    guard let authentication = user.authentication else { return }
    let credential = GoogleAuthProvider.credential(withIDToken: (authentication.idToken)!, accessToken: (authentication.accessToken)!)
    //When user is signed in
    Auth.auth().signIn(with: credential, completion: { (user, error) in
      if let error = error {
        print("Login error: \(error.localizedDescription)")
        let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        self.present(alertController, animated: true, completion: nil)
        
        return
      }
      //Present the main view
      self.performSegue(withIdentifier: self.signInSegue, sender: nil)
    })
    
  }
  
  // Start Google OAuth2 Authentication
  func sign(_ signIn: GIDSignIn?, present viewController: UIViewController?) {
    // Showing OAuth2 authentication window
    if let aController = viewController {
      present(aController, animated: true) {() -> Void in }
    }
  }
  
  // After Google OAuth2 authentication
  func sign(_ signIn: GIDSignIn?, dismiss viewController: UIViewController?) {
    // Close OAuth2 authentication window
    dismiss(animated: true) {() -> Void in }
  }
  
}
