//
//  HomeVC.swift
//  Amtrip
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
  private(set) var albumToPass: Album?
  
  private var notificationToken: NotificationToken? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()

    albums = Album.all()
    albumCollection.showsVerticalScrollIndicator = false
    navigationItem.hidesBackButton = true
    navigationItem.hideBackButtonText()
    
//    if let albums = self.albums {
//      for album in albums {
//        // Observe receivedPage's "images" property
//        notificationToken = album.observe { change in
//          guard let collectionView = self.albumCollection else { return }
//          switch change {
//          case .change(let properties):
//            for property in properties {
//              switch property.name {
//              case "images":
//                self.images = [UIImage]()
//                collectionView.reloadData()
//              default: break
//              }
//            }
//            break
//          case .error(let error):
//            print("Error occurred: \(error)")
//          case .deleted:
//            print("The page was deleted")
//          }
//        }
//      }
//    }
    // Observe receivedPage's "images" property
//    notificationToken = albums?.observe{ change in
//      guard let collectionView = self.albumCollection else { return }
//      switch change {
//      case .initial(let albums):
//        collectionView.reloadData()
//        break
//      case .update(let albums, let deletions, let insertions, let modifications):
//        collectionView.performBatchUpdates({
//          collectionView.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
//          collectionView.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
//          collectionView.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
//          collectionView.reloadData()
//        }, completion: nil)
//        print("The page was deleted")
//      case .error(let error):
//        print("Error occurred: \(error)")
//      }
//    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    albumCollection.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    setCollectionViewFlowLayout()
  }
  
  fileprivate func setCollectionViewFlowLayout() {
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
  
  @IBAction func unwindToHomeVC(segue: UIStoryboardSegue) {
    albumCollection.reloadData()
  }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return albums!.count
  }
  
  fileprivate func fetchImage(_ album: Album?) {
    let documentsURL = FileManager.documentDirectory
    
    for imagePath in album!.images {
      let filePath = documentsURL.appendingPathComponent(imagePath).path
      self.image = UIImage(contentsOfFile: filePath)
      self.images = [UIImage]()
      self.images.append(self.image!)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumThumbnailCell", for: indexPath) as! AlbumThumbnailCell
    
    let album = albums?[indexPath.row]
    self.images = [UIImage]()
    
    fetchImage(album)
    
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
    cell.albumTitle.preferredMaxLayoutWidth = albumCollection.bounds.width
    
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    var numberOfSections = 0
    if albums!.count == 0 {
      collectionView.setNoDataLabelForCollectionView()
    } else {
      numberOfSections = 1
      collectionView.backgroundView = nil
    }
    
    return numberOfSections
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    let album = albums?[indexPath.row]

    albumToPass = album
    
    self.performSegue(withIdentifier: "toAlbumDetail", sender: Any.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toAlbumDetail" {
      let albumDetailVC = segue.destination as! AlbumDetailVC
      albumDetailVC.recievedAlbum = albumToPass
    }
  }
}
