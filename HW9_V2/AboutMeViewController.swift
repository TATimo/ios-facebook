//
//  AboutMeViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/19.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        MenuButton.target = revealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
}
