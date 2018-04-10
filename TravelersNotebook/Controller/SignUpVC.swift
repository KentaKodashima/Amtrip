//
//  SignUpVC.swift
//  Traveler's Notebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class SignUpVC: UIViewController {
  
  @IBOutlet weak var signUpEmail: UITextField!
  @IBOutlet weak var signUpFirstName: UITextField!
  @IBOutlet weak var signUpLastName: UITextField!
  @IBOutlet weak var signUpPassword: UITextField!
  @IBOutlet weak var signUpBtn: UIButton!
  @IBOutlet weak var facebookSignUpBtn: UIButton!
  @IBOutlet weak var googleSignUpBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }

  
  @IBAction func signUpWithFacebook() {
  
  }
  
  @IBAction func signUpWithGoogle() {
  
  }
  
}
