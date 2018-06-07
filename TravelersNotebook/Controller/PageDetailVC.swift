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
  }
  
}
