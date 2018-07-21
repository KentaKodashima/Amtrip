//
//  NoDataScreen.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-07-14.
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

extension UITableView {
  
  public func setNoDataLabelForTableView() {
    let labelWidth = self.bounds.size.width
    let labelHeight = self.bounds.size.height
    let noDataLabel = UILabel(
      frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
    )
    let isJapanese: Bool = {
      if let languageCode = (Locale.current as NSLocale).object(forKey: .languageCode) as? String {
        return languageCode == "ja"
      }
      return false
    }()
    noDataLabel.text = NSLocalizedString("There are no pages yet.", comment: "")
    noDataLabel.textColor = AppColors.textBrown.value
    noDataLabel.font = isJapanese ? UIFont(name: "HiraKakuProN-W6", size: 18) : UIFont(name: "Futura", size: 18)
    noDataLabel.textAlignment = .center
    self.separatorStyle = .none
    self.backgroundColor = AppColors.backgroundBrown.value
    self.backgroundView = noDataLabel
  }
}

extension UICollectionView {
  
  public func setNoDataLabelForCollectionView() {
    let labelWidth = self.bounds.size.width
    let labelHeight = self.bounds.size.height
    let noDataLabel = UILabel(
      frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
    )
    let isJapanese: Bool = {
      if let languageCode = (Locale.current as NSLocale).object(forKey: .languageCode) as? String {
        return languageCode == "ja"
      }
      return false
    }()
    noDataLabel.text = NSLocalizedString("There are no pages yet.", comment: "")
    noDataLabel.textColor = AppColors.textBrown.value
    noDataLabel.font = isJapanese ? UIFont(name: "HiraKakuProN-W6", size: 18) : UIFont(name: "Futura", size: 18)
    noDataLabel.textAlignment = .center
    self.backgroundColor = AppColors.backgroundBrown.value
    self.backgroundView = noDataLabel
  }
}

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