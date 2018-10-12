//
//  NoDataScreen.swift
//  Amtrip
//
//  Created by Kenta Kodashima on 2018-07-14.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

extension Date {
  // Convert from Date() to String
  public func dateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy/MM/dd"
    let date = dateFormatter.string(from: self)
    
    return date
  }
}
