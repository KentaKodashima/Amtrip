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
  
  @IBOutlet weak var albumCollection: UICollectionView!
  
  private var albums: Results<Album>?
  private var image: UIImage?
  private var images = [UIImage]()
  var albumTitleToPass: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    albums = Album.all()
    albumCollection.showsVerticalScrollIndicator = false
  }
  
  override func viewDidLayoutSubviews() {
    
    let layout = UICollectionViewFlowLayout()
    let cellWidth = albumCollection.bounds.width
    let cellHeight = albumCollection.bounds.height / 2
    layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 10
    layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .vertical
    albumCollection.collectionViewLayout = layout
  }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return albums!.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumThumbnailCell", for: indexPath) as! AlbumThumbnailCell
    
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
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    var numberOfSections = 0
    if albums!.count == 0 {
      let labelWidth = collectionView.bounds.size.width
      let labelHeight = collectionView.bounds.size.height
      let noDataLabel = UILabel(
        frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
      )
      noDataLabel.text = "There are no pages yet."
      noDataLabel.textColor = #colorLiteral(red: 0.4, green: 0.3568627451, blue: 0.3019607843, alpha: 1)
      noDataLabel.font = UIFont(name: "Futura", size: 22)
      noDataLabel.textAlignment = .center
      collectionView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8549019608, blue: 0.7215686275, alpha: 1)
      collectionView.backgroundView = noDataLabel
    } else {
      numberOfSections = 1
    }
    
    return numberOfSections
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let album = albums?[indexPath.row]

    albumTitleToPass = album?.albumTitle
    
    self.performSegue(withIdentifier: "toAlbumDetail", sender: Any.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAlbumDetail" {
      let albumDetailVC = segue.destination as! AlbumDetailVC
      albumDetailVC.recievedAlbumTitle = albumTitleToPass
    }
  }
}
