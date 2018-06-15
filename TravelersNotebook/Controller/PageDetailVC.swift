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
  
  var recievedAlbumTitle: String?
  var recievedPageTitle: String?
  var recievedDate: String?
  var recievedLocation: String?
  var recievedBodyText: String?
  var receivedImagesPath = List<String>()
  var images = [UIImage]()
  
  var pages: Results<Page>?
  var page: Page?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    albumTitle.text = recievedAlbumTitle
    pageTitle.text = recievedPageTitle
    date.text = recievedDate
    location.text = recievedLocation
    bodyText.text = recievedBodyText
    
    let edgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    scrollView.contentInset = edgeInsets
    
    print(receivedImagesPath)
    print(receivedImagesPath.first!)
    
    fetchImage()
    pages = Page.all()
  }
  
  override func viewDidLayoutSubviews() {
    scrollView.flashScrollIndicators()
    
    let layout = UICollectionViewFlowLayout()
    layout.itemSize = CGSize(width: 200, height: 200)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .horizontal
    imageCollection.collectionViewLayout = layout
  }
  
  private func fetchImage() {
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentPath = documentsURL.path
    
    for imagePath in receivedImagesPath {
      
    }
    let image = UIImage(contentsOfFile: receivedImagesPath.first!)
    
    
    print(image)
  }
  
}

extension PageDetailVC: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  // Assign cells contents
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
    
    cell.cellImage.image = images[indexPath.row]
    imageCollection.isHidden = false
    
    return cell
  }
}
