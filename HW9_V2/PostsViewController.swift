//
//  PostsViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/17.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Foundation
import SwiftSpinner
import FBSDKShareKit

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate {
    var keyword: String?
    var type: String?
    var id: String?
    var name: String?
    var tmpDate: String?
    var avatarUrl: URL?
    var FavoDecider: String?
    var data: JSON?
    
    @IBOutlet weak var PostsData: UITableView!
    @IBOutlet weak var PostsNoData: UILabel!
    
    @IBAction func ResultButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "options"), style: .plain, target: self, action: #selector(FSOption))
        super.viewDidLoad()
        SwiftSpinner.show("Loading data...")
        PostsData.tableFooterView = UIView()
        PostsData.estimatedRowHeight = 100
        PostsData.rowHeight = UITableViewAutomaticDimension
        
        self.PostsNoData.text = ""
        
        let searchUrl = "http://qifanw2-env.us-west-2.elasticbeanstalk.com/index.php?detail_keyword=\(self.keyword!)&detail_type=\(self.type!)&detail_id=\(self.id!)"
        
        if self.type != "event" {
            Alamofire.request(searchUrl).responseJSON { response in
                if((response.result.value) != nil) {
                    self.data = JSON(response.result.value!)
                    self.PostsData.reloadData()
                    if self.data!["posts"] == JSON.null {
                        self.PostsNoData.textAlignment = NSTextAlignment.center
                        self.PostsNoData.text = "No data found."
                    }
                }
            }
        }else{
            self.PostsNoData.textAlignment = NSTextAlignment.center
            self.PostsNoData.text = "No data found."
        }
        SwiftSpinner.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*******************************Table Content*******************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((self.data) != nil){
            return (self.data?["posts"].count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PostsTableViewCell
        
        if((self.data) != nil){
            let imgData = try? Data(contentsOf: avatarUrl!)
            cell?.PostsImg.image = UIImage(data: imgData!)
            
            if self.data?["posts"][indexPath.row]["message"] != JSON.null {
                cell?.PostsText.text = self.data?["posts"][indexPath.row]["message"].string!
            }else if self.data?["posts"][indexPath.row]["story"] != JSON.null{
                cell?.PostsText.text = self.data?["posts"][indexPath.row]["story"].string!
            }else {cell?.PostsText.text = "No Post Text"}
            
            let DS = self.data?["posts"][indexPath.row]["created_time"]["date"].string!
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.zzzzzz"
            dataFormatter.locale = Locale.init(identifier: "en_US")
            
            if(DS != "null"){
                let dataObj = dataFormatter.date(from: DS!)
                dataFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                let finaldate = dataFormatter.string(from: dataObj!)
                cell?.PostsDate.text = finaldate
            }else{cell?.PostsDate.text = "No Date"}
        }
        return cell!
    }
    
    /*******************************Options*******************************/
    
    func FSOption(){
        var tmpid: String?
        var tmpname: String?
        var tmpurl: String?
        if(self.type == "event"){
            tmpid = self.id
            tmpname = self.name
        }else{
            tmpid = self.data!["id"].string!
            tmpname = self.data!["name"].string!
        }
        tmpurl = "\(self.avatarUrl!)"
        var tmpnamedic = UserDefaults.standard.dictionary(forKey: "name")
        var tmpimagedic = UserDefaults.standard.dictionary(forKey: "image")
        var tmpkeyworddic = UserDefaults.standard.dictionary(forKey: "keyword")
        var tmparray = [String]()
        tmparray = UserDefaults.standard.array(forKey: self.type!) as! [String]
        if !tmparray.contains(tmpid!) {
            FavoDecider = "Add to favorites"
        }else {
            FavoDecider = "Remove from favorites"
        }
        let alert:UIAlertController = UIAlertController(title: "Menu", message: nil, preferredStyle: .actionSheet)
        let action1:UIAlertAction = UIAlertAction(title: self.FavoDecider, style: .default) { (_:UIAlertAction) in
            if !tmparray.contains(tmpid!){
                /************************* page *************************/
                tmparray.append(tmpid!)
                UserDefaults.standard.set(tmparray, forKey: self.type!)
                /************************* name *************************/
                tmpnamedic?[tmpid!] = tmpname
                UserDefaults.standard.set(tmpnamedic, forKey: "name")
                /************************* image *************************/
                tmpimagedic?[tmpid!] = tmpurl
                UserDefaults.standard.set(tmpimagedic, forKey: "image")
                /************************* keyword *************************/
                tmpkeyworddic?[tmpid!] = self.keyword
                UserDefaults.standard.set(tmpkeyworddic, forKey: "keyword")
                self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
                self.view.toastTextColor = UIColor.white
                self.view.showToast("Added to favorites!", position: .bottom, popTime: 2, dismissOnTap: true)
            }else{
                /************************* name image keyword *************************/
                var duplicateCheck: Bool
                var dupArray = [String]()
                duplicateCheck = true
                if(self.type == "page"){
                    dupArray = UserDefaults.standard.array(forKey: "place") as! [String]
                    if dupArray.contains(tmpid!) {duplicateCheck = false}
                }else if(self.type == "place"){
                    dupArray = UserDefaults.standard.array(forKey: "page") as! [String]
                    if dupArray.contains(tmpid!) {duplicateCheck = false}
                }
                if(duplicateCheck == true){
                    tmpnamedic?[tmpid!] = nil
                    tmpimagedic?[tmpid!] = nil
                    tmpkeyworddic?[tmpid!] = nil
                    UserDefaults.standard.set(tmpnamedic, forKey: "name")
                    UserDefaults.standard.set(tmpimagedic, forKey: "image")
                    UserDefaults.standard.set(tmpkeyworddic, forKey: "keyword")
                }
                /************************* page *************************/
                tmparray = tmparray.filter{$0 != tmpid}
                UserDefaults.standard.set(tmparray, forKey: self.type!)
                self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
                self.view.toastTextColor = UIColor.white
                self.view.showToast("Removed from favorites!", position: .bottom, popTime: 2, dismissOnTap: true)
            }
        }
        let action2:UIAlertAction = UIAlertAction(title: "Share", style: .default) { (_:UIAlertAction) in
            let title = self.data?["name"].string!
            let decription = "FB Share For CSCI 571"
            let picture = self.avatarUrl
            
            let content: FBSDKShareLinkContent = FBSDKShareLinkContent()
            content.contentTitle = title
            content.contentDescription = decription
            content.imageURL = picture
            
            let dialog : FBSDKShareDialog = FBSDKShareDialog()
            //dialog.mode = FBSDKShareDialogMode.feedWeb
            dialog.fromViewController = self
            dialog.delegate = self
            dialog.shareContent = content
            dialog.show()
        }
        let action3:UIAlertAction = UIAlertAction(title: "Cancel", style: .destructive) { (_:UIAlertAction) in
            //Doing Nothing
        }
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(action3)
        self.present(alert, animated: true) {
            //Doing Nothing
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        if results.count == 0 {
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.showToast("Share Cancelled!", position: .bottom, popTime: 2, dismissOnTap: true)
        }else{
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: true)
        }
    }
    
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!) {
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.toastTextColor = UIColor.white
        self.view.showToast("Share Error", position: .bottom, popTime: 2, dismissOnTap: true)
    }
    
    func sharerDidCancel(_ sharer: FBSDKSharing!) {
        self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.toastTextColor = UIColor.white
        self.view.showToast("Share Cancelled", position: .bottom, popTime: 2, dismissOnTap: true)
    }
}
