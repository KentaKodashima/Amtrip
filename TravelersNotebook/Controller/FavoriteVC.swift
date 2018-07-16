//
//  FavoriteVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-03-28.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import RealmSwift

class FavoriteVC: UIViewController {
  
  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  
  private(set) var pages: Results<Page>?
  
  private(set) var pageToPass: Page?
  private(set) var albumToPass: Album?
  
  private var barBrown = AppColors.barBrown.value
  private var backgroundBrown = AppColors.backgroundBrown.value
  private var textBrown = AppColors.textBrown.value
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Search bar style
    searchBar.delegate = self
    searchBar.setSearchBar()
    
    pages = Page.favoritePages()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
    tableView.tableFooterView = UIView(frame: .zero)
  }
  
  // Unwind segue from PageDetailVC
  @IBAction func unwindToFavoriteVC(segue: UIStoryboardSegue) {
    tableView.reloadData()
  }
}

extension FavoriteVC: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
    if searchText.isEmpty {
      pages = Page.favoritePages()
      self.tableView.reloadData()
    } else {
      pages = Page.favoritePages().filter("pageTitle CONTAINS[cd] %@", searchText)
      self.tableView.reloadData()
    }
  }
}

extension FavoriteVC: UITableViewDelegate, UITableViewDataSource {
  
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
      pageDetailVC.receivedViewControllerName = "FavoriteVC"
      pageDetailVC.receivedAlbum = albumToPass
    }
  }
}
