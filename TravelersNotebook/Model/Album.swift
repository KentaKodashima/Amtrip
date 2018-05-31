//
//  Album.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-04-02.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import RealmSwift

class Album: Object {
//  enum Property: String {
//    case id, albumTitle, pages
//  }

//  @objc dynamic let id = UUID().uuidString
  @objc dynamic private(set) var albumTitle: String = ""
  var pages = List<Page>()
  //@objc dynamic var pages: [Page] = [Page]()

//  override static func primaryKey() -> String? {
//    return Album.Property.id.rawValue
//  }

  convenience init(albumTitle: String) {
    self.init()

    self.albumTitle = albumTitle
  }
}
