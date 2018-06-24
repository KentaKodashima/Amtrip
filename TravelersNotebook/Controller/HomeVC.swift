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
  private var images = [UIImage]()
  
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
      self.image = UIImage(contentsOfFile: filePath)
      self.images.append(self.image!)
    }

    cell.albumTitle.text = album?.albumTitle
    cell.dateLabel.text = album?.creationDate

    let numberOfImages = UInt32(self.images.count)
    let randomNum = Int(arc4random_uniform(numberOfImages))
    
    if album?.images.count == 0 {
      cell.bgImage?.image = nil
      cell.backgroundColor = #colorLiteral(red: 0.6784313725, green: 0.4235294118, blue: 0.2078431373, alpha: 1)
    } else {
      cell.bgImage?.image = images[randomNum]
    }
    
    cell.layoutMargins = UIEdgeInsets.zero
    cell.contentView.layoutMargins.top = 20
    cell.contentView.layoutMargins.bottom = 20
    
    return cell
  }
}
