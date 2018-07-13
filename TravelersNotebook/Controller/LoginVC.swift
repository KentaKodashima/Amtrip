//
//  LoginVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-05-23.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginVC: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    biometricsIdAuthentication()
  }
  
  func biometricsIdAuthentication() {
    let context = LAContext()
    let reason = "Unlock"
    var authError: NSError?
    
    if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
      context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluationError in
        if (success) {
          self.performSegue(withIdentifier: "authSuccess", sender: nil)
        } else {
          guard let error = evaluationError else {
            return
          }
        }
      }
    } else {
      guard let error = authError else {
        return
      }
    }
  }
  
}
