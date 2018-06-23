//
//  PageDetailVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-06-06.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import RealmSwift

class PageDetailVC: UIViewController {
  
  @IBOutlet weak var albumTitle: UILabel!
  @IBOutlet weak var pageTitle: UILabel!
  @IBOutlet weak var date: UILabel!
  @IBOutlet weak var location: UILabel!
  @IBOutlet weak var bodyText: UITextView!
  @IBOutlet weak var imageCollection: UICollectionView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  public var recievedAlbumTitle: String?
  public var recievedPageTitle: String?
  public var recievedDate: String?
  public var recievedLocation: String?
  public var recievedBodyText: String?
  public var receivedImagesPath = List<String>()
  private var images = [UIImage]()
  private var image: UIImage?
  
  private var indexOfCellBeforeDragging = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    albumTitle.text = recievedAlbumTitle
    pageTitle.text = recievedPageTitle
    date.text = recievedDate
    location.text = recievedLocation
    bodyText.text = recievedBodyText
    
    let edgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    scrollView.contentInset = edgeInsets
    
    imageCollection.isHidden = true
    
    fetchImage()
  }
  
  override func viewDidLayoutSubviews() {
    
    scrollView.flashScrollIndicators()
    
    let layout = UICollectionViewFlowLayout()
    let cellWidth = imageCollection.bounds.width
    let cellHeight = imageCollection.bounds.height
    layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .horizontal
    imageCollection.collectionViewLayout = layout
  }
  
  private func fetchImage() {
    
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    for imagePath in receivedImagesPath {
      let filePath = documentsURL.appendingPathComponent(imagePath).path
      self.image = UIImage(contentsOfFile: filePath)
      images.append(self.image!)
    }
  }
  
}

extension PageDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    print(images.count)
    return images.count
  }
  
  // Assign cells contents
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
    
    print(images.count)
    cell.cellImage.image = images[indexPath.row]
    cell.clipsToBounds = true
    imageCollection.isHidden = false
    
    return cell
  }
  
}
