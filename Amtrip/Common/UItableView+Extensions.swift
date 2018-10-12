//
//  UItableView+Extensions.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-10-11.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

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
