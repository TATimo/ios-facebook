//
//  DetailsViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/17.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class DetailsViewController: UITabBarController {
    var keyword: String?
    var type: String?
    var id: String?
    var name: String?
    var avatarUrl: URL?
    
    override func viewDidLoad() {
        self.navigationItem.title = "Details"
        self.navigationController?.navigationBar.topItem?.title = "Results";
        super.viewDidLoad()
        
        if let albumsController = self.viewControllers?[0] as? AlbumsViewController{
            albumsController.keyword = self.keyword
            albumsController.id = self.id
            albumsController.type = self.type
            albumsController.avatarUrl = self.avatarUrl
            if self.type == "event" {albumsController.name = self.name}
        }
        
        if let postsController = self.viewControllers?[1] as? PostsViewController{
            postsController.keyword = self.keyword
            postsController.id = self.id
            postsController.type = self.type
            postsController.avatarUrl = self.avatarUrl
            if self.type == "event" {postsController.name = self.name}
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
