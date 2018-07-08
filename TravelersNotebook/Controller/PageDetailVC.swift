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
  @IBOutlet weak var pageControl: UIPageControl!
  @IBOutlet weak var imageCollectionHeight: NSLayoutConstraint!
  
  public var receivedImagesPath = List<String>()
  public var receivedPage: Page?
  public var receivedViewControllerName: String?
  public var receivedAlbum: Album?
  
  private var images = [UIImage]()
  private var image: UIImage?

  private var favoriteButton = UIBarButtonItem()
  private var multiFuncButton = UIButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    albumTitle.text = receivedPage?.albumTitle
    pageTitle.text = receivedPage?.pageTitle
    date.text = receivedPage?.date
    location.text = receivedPage?.location
    bodyText.text = receivedPage?.bodyText
    
    let edgeInsets = UIEdgeInsets(top: 30, left: 0, bottom: 30, right: 0)
    scrollView.contentInset = edgeInsets
    
    favoriteButton = UIBarButtonItem(
      image: #imageLiteral(resourceName: "Heart"),
      style: .plain,
      target: self,
      action: #selector(favoriteButtonTapped)
    )
    if receivedPage?.isFavorite == true {
      favoriteButton.tintColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
    }
    
    multiFuncButton = UIButton(type: .custom)
    multiFuncButton.setImage(UIImage(named: "Meatball Menu"), for: .normal)
    multiFuncButton.addTarget(self, action: #selector(multiFuncButtonTapped), for: .touchUpInside)
    multiFuncButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    let multiFuncBarButton = UIBarButtonItem(customView: multiFuncButton)
    self.navigationItem.setRightBarButtonItems([multiFuncBarButton, favoriteButton], animated: true)
    
    imageCollection.isHidden = true
    pageControl.hidesForSinglePage = true
    
    navigationItem.title = receivedPage?.pageTitle
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Futura", size: 22)]
    
    fetchImage()
  }
  
  override func viewDidLayoutSubviews() {
    
    scrollView.flashScrollIndicators()
    
    let layout = UICollectionViewFlowLayout()
    imageCollectionHeight.constant = imageCollection.bounds.width
    let cellWidth = imageCollection.bounds.width
    let cellHeight = imageCollection.bounds.height
    layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.scrollDirection = .horizontal
    imageCollection.collectionViewLayout = layout
  }
  
  // Unwind segue from PageDetailVC
  @IBAction func unwindToPageDetailVC(segue: UIStoryboardSegue) {
    
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
  
  @objc private func multiFuncButtonTapped() {
    
    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let editButton = UIAlertAction(title: "Edit", style: .default) { (action: UIAlertAction) in
      self.performSegue(withIdentifier: "toEditVC", sender: self)
    }
    let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    let deleteButton = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
      
      self.deletePageFromRealm()
      
      if self.receivedViewControllerName == "SearchVC" {
        self.performSegue(withIdentifier: "unwindToSearchVC", sender: self)
      } else if self.receivedViewControllerName == "FavoriteVC" {
        self.performSegue(withIdentifier: "unwindToFavoriteVC", sender: self)
      } else if self.receivedViewControllerName == "AlbumDetailVC"{
        self.performSegue(withIdentifier: "unwindToAlbumDetailVC", sender: self)
      } else {
        self.performSegue(withIdentifier: "unwindToAccountVC", sender: self)
      }
    }
    
    alert.addAction(editButton)
    alert.addAction(cancelButton)
    alert.addAction(deleteButton)
    present(alert, animated: true, completion: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toEditVC" {
      let editVC = segue.destination as! EditVC
      editVC.receivedPage = self.receivedPage
    }
  }
  
  @objc private func favoriteButtonTapped() {
    
    let realm = try! Realm()
    
    if receivedPage?.isFavorite == false {
      try! realm.write {
        receivedPage?.isFavorite = true
      }
      favoriteButton.tintColor = #colorLiteral(red: 1, green: 0.5409764051, blue: 0.8473142982, alpha: 1)
    } else {
      try! realm.write {
        receivedPage?.isFavorite = false
        favoriteButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      }
    }
  }
  
  private func deletePageFromRealm() {
    
    let realm = try! Realm()
    let primaryKeyForPage = receivedPage?.key
    let primaryKeyForAlbum = receivedAlbum?.key
    let page = realm.object(ofType: Page.self, forPrimaryKey: primaryKeyForPage)
    let album = realm.object(ofType: Album.self, forPrimaryKey: primaryKeyForAlbum)
    
    // Delete file from the document directory
    let filemanager = FileManager.default
    let documentsURL = filemanager.urls(for: .documentDirectory, in: .userDomainMask).first!
    let documentPath = documentsURL.path
    if page?.images != nil {
      for image in (page?.images)! {
        let filePath = documentPath + "/" + image
        if filemanager.fileExists(atPath: filePath) {
          try! filemanager.removeItem(atPath: filePath)
        }
      }
    }
    
    try! realm.write {
      realm.delete(page!)
      
      if album?.pages.count == 0 {
        realm.delete(album!)
        self.performSegue(withIdentifier: "unwindToHome", sender: self)
      }
    }
  }
  
}

extension PageDetailVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    pageControl.numberOfPages = images.count
    
    return images.count
  }
  
  // Assign cells contents
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCell
    
    cell.cellImage.image = images[indexPath.row]
    cell.clipsToBounds = true
    imageCollection.isHidden = false
    
    return cell
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
  }
  
}
