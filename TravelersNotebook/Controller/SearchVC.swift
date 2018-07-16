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
  var pageToPass: Page?
  var albumToPass: Album?
  
  // Data for the tableView
  var cellCount = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Search bar style
    searchBar.delegate = self
    searchBar.setSearchBar()
    
    pages = Page.all()
    
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  override func viewWillAppear(_ animated: Bool) {
    
    tableView.reloadData()
  }
  
  // Unwind segue from PageDetailVC
  @IBAction func unwindToSearchVC(segue: UIStoryboardSegue) {
    tableView.reloadData()
  }
}

extension SearchVC: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    let realm = try! Realm()
    
    if searchText.isEmpty {
      pages = Page.all()
      self.tableView.reloadData()
    } else {
      
      // [c] case insensitive: lowercase & uppercase values are treated the same
      // [d] diacritic insensitive: special characters treated as the base character
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
      // Create NoDataLabel
      tableView.setNoDataLabelForTableView()
    } else {
      numberOfSections = 1
      tableView.backgroundView = nil
    }
    
    return numberOfSections
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let page = pages?[indexPath.row]
    pageToPass = page
    
    albumToPass = Album.albumWithTheKey(albumKey: page!.whatAlbumToBelong)
    
    self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPageDetail" {
      let pageDetailVC = segue.destination as! PageDetailVC
      
      pageDetailVC.receivedPage = pageToPass
      pageDetailVC.receivedViewControllerName = "SearchVC"
      pageDetailVC.receivedAlbum = albumToPass
    }
  }
}
