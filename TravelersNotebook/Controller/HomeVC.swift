//
//  HomeVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import RealmSwift

class HomeVC: UIViewController {

  @IBOutlet weak var albumTable: UITableView!
  
  var albums: Results<Album>?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    albums = Album.all()
    albumTable.reloadData()
  }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return albums!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AlbumThumbnailCell
    
    let album = albums?[indexPath.row]
    cell.albumTitle.text = album?.albumTitle
    cell.dateLabel.text = album?.creationDate
    
    return cell
  }
}
