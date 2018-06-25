//
//  SearchVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import RealmSwift

class SearchVC: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!
  
  var pages: Results<Page>?
  
  // Temporary properties for passing data to PageDetailVC
  var albumTitleToPass: String?
  var pageTitleToPass: String?
  var dateToPass: String?
  var locationToPass: String?
  var bodyTextToPass: String?
  var imagesToPass = List<String>()
  
  // Data for the tableView
  var cellCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
    pages = Page.all()
  }
  
}

extension SearchVC: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    let realm = try! Realm()
    
    if searchText.isEmpty {
      pages = Page.all()
      self.tableView.reloadData()
    } else {
      pages = realm.objects(Page.self).filter("pageTitle CONTAINS[cd] %@", searchText)
      self.tableView.reloadData()
    }
  }
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return pages!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
    
    let page = pages?[indexPath.row]
    cell.pageName.text = page?.pageTitle
    
    return cell
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    var numberOfSections = 0
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
    
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let page = pages?[indexPath.row]
    
    albumTitleToPass = page?.albumTitle
    pageTitleToPass = page?.pageTitle
    dateToPass = page?.date
    locationToPass = page?.location
    bodyTextToPass = page?.bodyText
    if page?.images != nil {
      imagesToPass = page!.images
    }
    
    self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPageDetail" {
      let pageDetailVC = segue.destination as! PageDetailVC
      
      pageDetailVC.recievedAlbumTitle = albumTitleToPass
      pageDetailVC.recievedPageTitle = pageTitleToPass
      pageDetailVC.recievedDate = dateToPass
      pageDetailVC.recievedLocation = locationToPass
      pageDetailVC.recievedBodyText = bodyTextToPass
      pageDetailVC.receivedImagesPath = imagesToPass
    }
  }
  
}
