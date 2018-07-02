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
  
  var pages: Results<Page>?
  
  var imagesToPass = List<String>()
  var pageToPass: Page?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    pages = Page.favoritePages()
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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let page = pages?[indexPath.row]
    
    pageToPass = page
    if page?.images != nil {
      imagesToPass = page!.images
    }
    
    self.performSegue(withIdentifier: "toPageDetail", sender: Any.self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toPageDetail" {
      let pageDetailVC = segue.destination as! PageDetailVC
      
      pageDetailVC.receivedPage = pageToPass
      pageDetailVC.receivedImagesPath = imagesToPass
    }
  }
}
