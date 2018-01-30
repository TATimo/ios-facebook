//
//  CustonCell.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/16.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class CustonCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var ResultName: UILabel!
    @IBOutlet weak var ResultImg: UIImageView!
    @IBOutlet weak var FavoritesButton: UIButton!
}
