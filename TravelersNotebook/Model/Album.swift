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
  @objc dynamic var albumTitle: String?
  @objc dynamic var pages: [Page]?
  
  convenience init(albumTitle: String) {
    self.init()
    
    self.albumTitle = albumTitle
    self.pages = [Page]()
  }
}
