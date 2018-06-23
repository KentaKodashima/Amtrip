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
  
  private var albums: Results<Album>?
  private var image: UIImage?
  private var images: [UIImage]?
  
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumThumbnailCell", for: indexPath) as! AlbumThumbnailCell
    
    let album = albums?[indexPath.row]
    
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    for imagePath in album!.images {
      let filePath = documentsURL.appendingPathComponent(imagePath).path
      image = UIImage(contentsOfFile: filePath)
      images?.append(self.image!)
    }
    
    cell.albumTitle.text = album?.albumTitle
    cell.dateLabel.text = album?.creationDate
    
    let numberOfImages = UInt32(images!.count)
    let randomNum = Int(arc4random_uniform(numberOfImages))
    
    if let image = album?.images {
      cell.bgImage?.image = nil
    } else {
      cell.bgImage?.image = images![randomNum]
    }
    
    return cell
  }
}
