//
//  Colors.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-07-13.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

enum AppColors {
  case textBrown
  case backgroundBrown
  case barBrown
}

extension AppColors {
  var value: UIColor {
    var color = UIColor.clear
    switch self {
    case .textBrown:
      color = #colorLiteral(red: 0.4, green: 0.3568627451, blue: 0.3019607843, alpha: 1)
    case .backgroundBrown:
      color = #colorLiteral(red: 0.9450980392, green: 0.8549019608, blue: 0.7215686275, alpha: 1)
    case .barBrown:
      color = #colorLiteral(red: 0.6784313725, green: 0.4235294118, blue: 0.2078431373, alpha: 1)
    }
    return color
  }
}
