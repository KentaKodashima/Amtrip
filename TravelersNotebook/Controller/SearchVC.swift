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
  
  //lazy var realm = try! Realm()
  var pages: Results<Page>?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    pages = Page.all()
  }
  
}

extension SearchVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return pages!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PageCell", for: indexPath) as! PageCell
    
    let page = pages?[indexPath.row]
//    if let pageTitle = page?.pageTitle {
//      cell.pageName.text = pageTitle
//    }
    cell.pageName.text = page?.pageTitle
    
    return cell
  }
}
