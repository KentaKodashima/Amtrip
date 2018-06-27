//
//  AlbumDetailVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-06-13.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumDetailVC: UIViewController {
  
  private var pages: Results<Page>?
  
  // Temporary properties for passing data to PageDetailVC
  var recievedAlbumTitle: String?
  var pageToPass: Page?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pages = Page.pagesInAlbum(albumTitle: recievedAlbumTitle!)
  }
}

extension AlbumDetailVC: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return pages!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
    
    let page = pages?[indexPath.row]
    cell.pageName.text = page?.pageTitle
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let page = pages?[indexPath.row]
    
    pageToPass = page
    
    self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toPageDetail" {
      
      let pageDetailVC = segue.destination as! PageDetailVC

      pageDetailVC.receivedPage = pageToPass
    }
  }
  
  
}
