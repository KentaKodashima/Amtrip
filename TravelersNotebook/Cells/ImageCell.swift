//
//  ImageCell.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-04-14.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
  @IBOutlet weak var cellImage: UIImageView!
  
  override init(frame: CGRect){
    super.init(frame: frame)
  }
  
  required init(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)!
  }
}
