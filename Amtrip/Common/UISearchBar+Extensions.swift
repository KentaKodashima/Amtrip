
//
//  File.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-10-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation

extension UISearchBar {
  public func setSearchBar() {
    // Search bar style
    self.isTranslucent = false
    let searchTextField = self.value(forKey: "_searchField") as? UITextField
    let searchImageView = self.value(forKey: "_background") as? UIImageView
    searchImageView?.removeFromSuperview()
    self.backgroundColor = AppColors.barBrown.value
    // Remove the borders
    self.layer.borderColor = AppColors.barBrown.value.cgColor
    self.layer.borderWidth = 1
    
    // Change icon color of UISearchBar
    let glassIcon = searchTextField?.leftView as? UIImageView
    glassIcon?.image = glassIcon?.image?.withRenderingMode(.alwaysTemplate)
    glassIcon?.tintColor = AppColors.backgroundBrown.value
  }
}
