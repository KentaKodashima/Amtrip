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
  var selectedIndex = 0
  
  // Temporary properties for passing data to PageDetailVC
  var albumTitleToPass: String?
  var pageToPass: Page?
  var albumToPass: Album?
  var imagesToPass = List<String>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pages = Page.all()
    albums = Album.all()
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  @IBAction func segmentValueChanged(_ sender: Any) {
    switch segmentedControl.selectedSegmentIndex {
    case 0:
      selectedIndex = 0
    default:
      selectedIndex = 1
    }
    
    self.tableView.reloadData()
  }
  
  // Unwind segue from PageDetailVC
  @IBAction func unwindToAccountVC(segue: UIStoryboardSegue) {
    tableView.reloadData()
  }
}

extension AccountVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var returnCount = 0
    
    switch selectedIndex {
    case 0:
      returnCount = albums!.count
    case 1:
      returnCount = pages!.count
    default:
      returnCount = albums!.count
    }
    
    return returnCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let albumCell = tableView.dequeueReusableCell(withIdentifier: "AlbumTitleCell", for: indexPath) as! AlbumTitleCell
    let pageCell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
    
    switch selectedIndex {
    case 0:
      
      let album = albums?[indexPath.row]
      albumCell.albumTitle.text = album?.albumTitle
      return albumCell
    case 1:
      
      let page = pages?[indexPath.row]
      pageCell.pageName.text = page?.pageTitle
      return pageCell
    default:
      
      return albumCell
    }
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    var numberOfSections = 0
    switch selectedIndex {
    case 0:
      if albums!.count == 0 {
        tableView.setNoDataLabelForTableView()
      } else {
        numberOfSections = 1
        tableView.backgroundView = nil
      }
    case 1:
      if pages!.count == 0 {
        tableView.setNoDataLabelForTableView()
      } else {
        numberOfSections = 1
        tableView.backgroundView = nil
      }
    default:
      return numberOfSections
    }
    
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let tappedCell = tableView.cellForRow(at: indexPath)
    
    if tappedCell?.reuseIdentifier == "AlbumTitleCell" {
      
      let album = albums?[indexPath.row]
      
      albumTitleToPass = album?.albumTitle
      albumToPass = album
      
      self.performSegue(withIdentifier: "toAlbumDetail", sender: Any.self)
    } else {
      let page = pages?[indexPath.row]
      
      pageToPass = page
      if page?.images != nil {
        imagesToPass = page!.images
      }
      
      albumToPass = Album.albumWithTheKey(albumKey: page!.whatAlbumToBelong)
      
      self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPageDetail" {
      
      let pageDetailVC = segue.destination as! PageDetailVC
      pageDetailVC.receivedPage = pageToPass
      pageDetailVC.receivedImagesPath = imagesToPass
      pageDetailVC.receivedViewControllerName = "AccountVC"
      pageDetailVC.receivedAlbum = albumToPass
    } else {
      let albumDetailVC = segue.destination as! AlbumDetailVC
      albumDetailVC.recievedAlbumTitle = albumTitleToPass
      albumDetailVC.recievedAlbum = albumToPass
    }
  }
}
