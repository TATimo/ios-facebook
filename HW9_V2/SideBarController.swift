//
//  SideBarController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/20.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class SideBarController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBOutlet weak var Favorites: UITableViewCell!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "favorites"){
            let navVC = segue.destination as? UINavigationController
            let resultScene = navVC?.viewControllers.first as! TotalViewController
            resultScene.mode = "favorites"
        }
    }
}
