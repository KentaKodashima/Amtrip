//
//  Album.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-04-02.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers class Album: Object {
  
  enum Property: String {
    case key, albumTitle, pages
  }

  @objc dynamic private(set) var key = UUID().uuidString
  @objc dynamic private(set) var albumTitle: String = ""
  @objc dynamic private(set) var creationDate: String = ""
  var pages = List<Page>()
  var images = List<String>()

  override static func primaryKey() -> String? {
    return Album.Property.key.rawValue
  }

  convenience init(albumTitle: String, creationDate: String) {
    self.init()

    self.albumTitle = albumTitle
    self.creationDate = creationDate
  }
  
  static func all(in realm: Realm = try! Realm()) -> Results<Album> {
    return realm.objects(Album.self)
  }
  
  static func albumWithTheKey(albumKey: String, in realm: Realm = try! Realm()) -> Album {
    return realm.object(ofType: Album.self, forPrimaryKey: albumKey)!
  }
}
