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
  var albumTitleToPass: String?
  var pageTitleToPass: String?
  var dateToPass: String?
  var locationToPass: String?
  var bodyTextToPass: String?
  var images = List<String>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    pages = Page.all()
  }
  
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return pages!.count
//    if searchBar.text != "" {
//
//    } else {
//      return pages!.count
//    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
    
    let page = pages?[indexPath.row]
    cell.pageName.text = page?.pageTitle
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let page = pages?[indexPath.row]
    
    albumTitleToPass = page?.albumTitle
    pageTitleToPass = page?.pageTitle
    dateToPass = page?.date
    locationToPass = page?.location
    bodyTextToPass = page?.bodyText
    
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
      
    }
  }
  
}
