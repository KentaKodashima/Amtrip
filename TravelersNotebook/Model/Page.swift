//
//  Page.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-04-14.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

class Page {
  var albumTitle: String
  var pageTitle: String
  var date: String
  var location: String
  var bodyText: String
  
  init(albumTitle: String, pageTitle: String, date: String, location: String, bodyText: String) {
    self.albumTitle = albumTitle
    self.pageTitle = pageTitle
    self.date = date
    self.location = location
    self.bodyText = bodyText
  }
}
