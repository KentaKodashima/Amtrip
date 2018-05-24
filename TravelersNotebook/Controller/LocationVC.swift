//
//  LocationVCViewController.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-05-20.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class LocationVC: CreateVC {
  
  @IBOutlet weak var localSerchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

      localSerchBar.becomeFirstResponder()
    }

}
