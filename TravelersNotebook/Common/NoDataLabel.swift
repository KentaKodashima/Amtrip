//
//  NoDataScreen.swift
//  TravelersNotebook
//
//  Created by Kenta Kodashima on 2018-07-14.
//  Copyright © 2018 Kenta Kodashima. All rights reserved.
//

import Foundation
import UIKit

class NoDataLabel {
  
  private var barBrown = AppColors.barBrown.value
  private var backgroundBrown = AppColors.backgroundBrown.value
  private var textBrown = AppColors.textBrown.value
  
  public func setNoDataLabelForTableView(tableView: UITableView) {
    let labelWidth = tableView.bounds.size.width
    let labelHeight = tableView.bounds.size.height
    let noDataLabel = UILabel(
      frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
    )
    noDataLabel.text = "There are no pages yet."
    noDataLabel.textColor = textBrown
    noDataLabel.font = UIFont(name: "Futura", size: 22)
    noDataLabel.textAlignment = .center
    tableView.separatorStyle = .none
    tableView.backgroundColor = backgroundBrown
    tableView.backgroundView = noDataLabel
  }
  
  public func setNoDataLabelForCollectionView(collectionView: UICollectionView) {
    let labelWidth = collectionView.bounds.size.width
    let labelHeight = collectionView.bounds.size.height
    let noDataLabel = UILabel(
      frame: CGRect(x: 0, y: 0, width: labelWidth, height: labelHeight)
    )
    noDataLabel.text = "There are no pages yet."
    noDataLabel.textColor = textBrown
    noDataLabel.font = UIFont(name: "Futura", size: 22)
    noDataLabel.textAlignment = .center
    collectionView.backgroundColor = backgroundBrown
    collectionView.backgroundView = noDataLabel
  }
}
