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

@objcMembers class Page: Object {
  
  enum Property: String {
    case key, albumTitle, pageTitle, date, location, bodyText, images
  }

  @objc dynamic private var key = UUID().uuidString
  @objc dynamic private(set) var albumTitle: String = ""
  @objc dynamic private(set) var pageTitle: String = ""
  @objc dynamic private(set) var date: String = ""
  @objc dynamic private(set) var location: String = ""
  @objc dynamic private(set) var bodyText: String = ""
  var images = List<String>()

  override static func primaryKey() -> String? {
    return Page.Property.key.rawValue
  }

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

extension Page {
  
  static func all(in realm: Realm = try! Realm()) -> Results<Page> {
    return realm.objects(Page.self).sorted(byKeyPath: Page.Property.date.rawValue)
  }
  
//  static func imagesPath(in realm: Realm = try! Realm()) -> Results<Page> {
//    let realmObjects = realm.objects(Page.self)
//    let imagesPath: [String]
//    
//    for (i = 0; realmObjects.count)
//    
//    return
//  }
  
}
