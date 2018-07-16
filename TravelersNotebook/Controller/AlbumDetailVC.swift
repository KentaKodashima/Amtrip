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
  
  @IBOutlet weak var tableView: UITableView!
  
  private var pages: Results<Page>?
  
  // Temporary properties for passing data to PageDetailVC
  var recievedAlbumTitle: String?
  var recievedAlbum: Album?
  var pageToPass: Page?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pages = Page.pagesInAlbum(albumTitle: recievedAlbum!.albumTitle)
    tableView.tableFooterView = UIView(frame: .zero)
    
    navigationItem.title = "Album Detail"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Futura", size: 22)]
  }
  
  override func viewWillAppear(_ animated: Bool) {
     tableView.reloadData()
  }
  
  // Unwind segue from PageDetailVC
  @IBAction func unwindToAlbumDetailVC(segue: UIStoryboardSegue) {
    tableView.reloadData()
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
    tableView.deselectRow(at: indexPath, animated: true)
    
    let page = pages?[indexPath.row]
    
    pageToPass = page
    
    self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    
    var numberOfSections = 0
    if pages!.count == 0 {
      tableView.setNoDataLabelForTableView()
    } else {
      numberOfSections = 1
    }
    
    return numberOfSections
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toPageDetail" {
      
      let pageDetailVC = segue.destination as! PageDetailVC

      pageDetailVC.receivedPage = pageToPass
      pageDetailVC.receivedViewControllerName = "AlbumDetailVC"
      pageDetailVC.receivedAlbum = self.recievedAlbum
    }
  }
  
  
}
