//
//  TotalViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/17.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class TotalViewController: UITabBarController {
    var keyword: String?
    var mode: String?
    var lat: Double?
    var lng: Double?
    
    override func viewDidLoad() {
        self.navigationItem.title = "FB Search"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(SWRevealViewController.revealToggle(_:)))
        self.navigationItem.leftBarButtonItem?.target = revealViewController()
        super.viewDidLoad()
        
        if self.mode == "search" {
            if let userController = self.viewControllers?[0] as? ResultViewController{
                userController.keyword = self.keyword
                userController.mode = self.mode
                if (self.lng != nil && self.lat != nil) {
                    userController.lat = self.lat
                    userController.lng = self.lng
                }
            }
            
            if let pageController = self.viewControllers?[1] as? PagesViewController{
                pageController.keyword = self.keyword
                pageController.mode = self.mode
                if (self.lng != nil && self.lat != nil) {
                    pageController.lat = self.lat
                    pageController.lng = self.lng
                }
            }
            
            if let placeController = self.viewControllers?[3] as? PlacesViewController{
                placeController.keyword = self.keyword
                placeController.mode = self.mode
                if (self.lng != nil && self.lat != nil) {
                    placeController.lat = self.lat
                    placeController.lng = self.lng
                }
            }
            
            if let eventController = self.viewControllers?[2] as? EventsViewController{
                eventController.keyword = self.keyword
                eventController.mode = self.mode
                if (self.lng != nil && self.lat != nil) {
                    eventController.lat = self.lat
                    eventController.lng = self.lng
                }
            }
            
            if let groupController = self.viewControllers?[4] as? GroupsViewController{
                groupController.keyword = self.keyword
                groupController.mode = self.mode
                if (self.lng != nil && self.lat != nil) {
                    groupController.lat = self.lat
                    groupController.lng = self.lng
                }
            }
        }else if self.mode == "favorites"{
            print("Favorites Mode")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
