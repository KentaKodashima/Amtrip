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
  
  var albumTitleToPass: String?
  var pageTitleToPass: String?
  var dateToPass: String?
  var locationToPass: String?
  var bodyTextToPass: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pages = Page.all()
    albums = Album.all()
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
        let labelWidth = tableView.bounds.size.width
        let labelHeight = tableView.bounds.size.height
        let noDataLabel = UILabel(
          frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        )
        noDataLabel.text = "There are no pages yet."
        noDataLabel.textColor = #colorLiteral(red: 0.4, green: 0.3568627451, blue: 0.3019607843, alpha: 1)
        noDataLabel.font = UIFont(name: "Futura", size: 22)
        noDataLabel.textAlignment = .center
        tableView.separatorStyle = .none
        tableView.backgroundView = noDataLabel
      } else {
        numberOfSections = 1
      }
    case 1:
      
      if pages!.count == 0 {
        let labelWidth = tableView.bounds.size.width
        let labelHeight = tableView.bounds.size.height
        let noDataLabel = UILabel(
          frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
        )
        noDataLabel.text = "There are no pages yet."
        noDataLabel.textColor = #colorLiteral(red: 0.4, green: 0.3568627451, blue: 0.3019607843, alpha: 1)
        noDataLabel.font = UIFont(name: "Futura", size: 22)
        noDataLabel.textAlignment = .center
        tableView.separatorStyle = .none
        tableView.backgroundView = noDataLabel
      } else {
        numberOfSections = 1
      }
    default:
      
      return numberOfSections
    }
    
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let tappedCell = tableView.cellForRow(at: indexPath)
    
    if tappedCell?.reuseIdentifier == "AlbumTitleCell" {
      
      let album = albums?[indexPath.row]
      
      albumTitleToPass = album?.albumTitle
      
      self.performSegue(withIdentifier: "toAlbumDetail", sender: Any.self)
    } else {
      
      let page = pages?[indexPath.row]
      
      albumTitleToPass = page?.albumTitle
      pageTitleToPass = page?.pageTitle
      dateToPass = page?.date
      locationToPass = page?.location
      bodyTextToPass = page?.bodyText
      
      self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toPageDetail" {
      
      let pageDetailVC = segue.destination as! PageDetailVC
      pageDetailVC.recievedAlbumTitle = albumTitleToPass
      pageDetailVC.recievedPageTitle = pageTitleToPass
      pageDetailVC.recievedDate = dateToPass
      pageDetailVC.recievedLocation = locationToPass
      pageDetailVC.recievedBodyText = bodyTextToPass
    } else {
      let albumDetailVC = segue.destination as! AlbumDetailVC
      albumDetailVC.recievedAlbumTitle = albumTitleToPass
    }
  }
}
