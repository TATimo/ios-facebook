//
//  AlbumsTableViewCell.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/18.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var AlbumsName: UILabel!
    @IBOutlet weak var AP1: UIImageView!
    @IBOutlet weak var AP2: UIImageView!
    
    var isObserving = false

    class var defaultHeight: CGFloat{get{return 40}}
    class var onePicHeight: CGFloat{get{return 260}}
    class var twoPicHeight: CGFloat{get{return 500}}
    
    func checkHeight() {
        if(self.AP1 != nil) {AP1.isHidden = (frame.size.height < AlbumsTableViewCell.onePicHeight)}
        if(self.AP2 != nil) {AP2.isHidden = (frame.size.height < AlbumsTableViewCell.twoPicHeight)}
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
}
