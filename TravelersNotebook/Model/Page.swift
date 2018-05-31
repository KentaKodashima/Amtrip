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
  
//  enum Property: String {
//    case id, albumTitle, pageTitle, date, location, bodyText
//  }

  //@objc dynamic private let id = UUID().uuidString
  @objc dynamic private(set) var albumTitle: String = ""
  @objc dynamic private(set) var pageTitle: String = ""
  @objc dynamic private(set) var date: String = ""
  @objc dynamic private(set) var location: String = ""
  @objc dynamic private(set) var bodyText: String = ""
  var image = List<Data>()

//  override static func primaryKey() -> String? {
//    return "id"
//  }

  convenience init(
    albumTitle: String,
    pageTitle: String,
    date: String,
    location: String,
    bodyText: String
    ) {
    self.init()
    self.albumTitle = albumTitle
    self.pageTitle = pageTitle
    self.date = date
    self.location = location
    self.bodyText = bodyText
  }
}
