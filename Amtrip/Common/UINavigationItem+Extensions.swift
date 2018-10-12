//
//  UINavigationItem+Extensions.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-10-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationItem {
  public func hideBackButtonText() {
    let backButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    self.backBarButtonItem = backButton
  }
}
