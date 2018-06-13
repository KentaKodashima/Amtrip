//
//  AccountVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//


import UIKit
import RealmSwift

class AccountVC: UIViewController {
  
  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var tableView: UITableView!
  
  var pages: Results<Page>?
  var albums: Results<Album>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    segmentedControl.selectedSegmentIndex = 0
    
    pages = Page.all()
    albums = Album.all()
  }
  
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      return albums!.count
    case 1:
      return pages!.count
    default:
      return albums!.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTitleCell", for: indexPath) as! AlbumTitleCell
      let album = albums?[indexPath.row]
      cell.albumTitle.text = album?.albumTitle
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
      let page = pages?[indexPath.row]
      cell.pageName.text = page?.pageTitle
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTitleCell", for: indexPath) as! AlbumTitleCell
      let album = albums?[indexPath.row]
      cell.albumTitle.text = album?.albumTitle
      return cell
    }
  }
}
