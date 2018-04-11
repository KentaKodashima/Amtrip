//
//  SignUpVC.swift
//  Traveler's Notebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseFacebookAuthUI

class SignUpVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var signUpEmail: UITextField!
  @IBOutlet weak var signUpFirstName: UITextField!
  @IBOutlet weak var signUpLastName: UITextField!
  @IBOutlet weak var signUpPassword: UITextField!
  
  private let signInSegue = "moveOnToTopPage"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Enable return key of UITextFields
    self.signUpFirstName.delegate = self
    self.signUpLastName.delegate = self
    self.signUpEmail.delegate = self
    self.signUpPassword.delegate = self
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
  
}
