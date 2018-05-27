//
//  AlbumCreateVC.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-05-27.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class AlbumCreateVC: UIViewController {
  
  var albumTitles: [String]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  @IBAction func createButtonTapped(_ sender: UIButton) {
    
  }
  
}

extension AlbumCreateVC: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    albumTitles?.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    <#code#>
  }
  
}
