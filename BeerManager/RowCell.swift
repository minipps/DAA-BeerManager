//
//  RowCell.swift
//  BeerManager
//
//  Created by  AlbaCruz on 01/01/2021.
//  Copyright © 2021  AlbaCruz. All rights reserved.
//

import Foundation
import UIKit

class RowCell : UITableViewCell {
    //MARK: Outlets
    @IBOutlet weak var beerPhoto:UIImageView?
    @IBOutlet weak var beerName:UILabel?
    //MARK: awakeFromNib
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    //MARK: setSelected
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
