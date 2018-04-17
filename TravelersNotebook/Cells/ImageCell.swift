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
  
  override func prepareForReuse() {
    cellImage.image = nil
  }
}
