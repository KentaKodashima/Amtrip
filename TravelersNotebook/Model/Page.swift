//
//  Page.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-04-14.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Page: Object {
  @objc dynamic private var albumTitle: String?
  @objc dynamic private var pageTitle: String?
  @objc dynamic private var date: String?
  @objc dynamic private var location: String?
  @objc dynamic private var bodyText: String?
  
  convenience init(albumTitle: String, pageTitle: String, date: String, location: String, bodyText: String) {
    self.init()
    self.albumTitle = albumTitle
    self.pageTitle = pageTitle
    self.date = date
    self.location = location
    self.bodyText = bodyText
  }
}
