//
//  PostsTableViewCell.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/18.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class PostsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var PostsImg: UIImageView!
    @IBOutlet weak var PostsDate: UILabel!
    @IBOutlet weak var PostsText: UILabel!
}
