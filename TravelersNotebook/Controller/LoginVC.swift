//
//  LoginVC.swift
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

class LoginVC: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var loginEmail: UITextField!
  @IBOutlet weak var loginPassword: UITextField!
  private let signInSegue = "continueToTopPage"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Enable return key of UITextFields
    self.loginEmail.delegate = self
    self.loginPassword.delegate = self
  }
  
  /*
   Enable return key of UITextFields
   */
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    loginEmail.resignFirstResponder()
    loginPassword.resignFirstResponder()
    
    return true
  }
  
  @IBAction func loginDidTouch() {
    Auth.auth().signIn(
      withEmail: loginEmail.text!,
      password: loginPassword.text!
    )
    performSegue(withIdentifier: signInSegue, sender: nil)
  }
  
}
