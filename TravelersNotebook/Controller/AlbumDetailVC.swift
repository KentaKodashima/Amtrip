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
  
  var imagesToPass = List<String>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pages = Page.pagesInAlbum(albumTitle: recievedAlbumTitle!)
    tableView.tableFooterView = UIView(frame: .zero)
    
    navigationItem.title = "Album Detail"
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Futura", size: 22)]
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
    
    let page = pages?[indexPath.row]
    
    pageToPass = page
    if page?.images != nil {
      imagesToPass = page!.images
    }
    
    self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
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
      tableView.backgroundColor = #colorLiteral(red: 0.9450980392, green: 0.8549019608, blue: 0.7215686275, alpha: 1)
      tableView.backgroundView = noDataLabel
    } else {
      numberOfSections = 1
    }
    
    return numberOfSections
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if segue.identifier == "toPageDetail" {
      
      let pageDetailVC = segue.destination as! PageDetailVC

      pageDetailVC.receivedPage = pageToPass
      pageDetailVC.receivedImagesPath = imagesToPass
      pageDetailVC.receivedViewControllerName = "AlbumDetailVC"
      pageDetailVC.receivedAlbum = self.recievedAlbum
    }
  }
  
  
}
