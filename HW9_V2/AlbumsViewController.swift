//
//  AlbumsViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/17.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner
import FBSDKShareKit
import FBSDKLoginKit
import EasyToast

class AlbumsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FBSDKSharingDelegate {
    var keyword: String?
    var type: String?
    var id: String?
    var name: String?
    var FavoDecider: String?
    var avatarUrl: URL?
    var data: JSON?
    var selectedIndexPath: IndexPath?
    
    @IBOutlet weak var AlbumsTable: UITableView!
    @IBOutlet weak var AlbumsNoData: UILabel!
    
    override func viewDidLoad() {
        tabBarController?.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "options"), style: .plain, target: self, action: #selector(FSOption))
        super.viewDidLoad()
        SwiftSpinner.show("Loading data...")
        AlbumsTable.tableFooterView = UIView()
        self.AlbumsNoData.text = ""
        
        let searchUrl = "http://qifanw2-env.us-west-2.elasticbeanstalk.com/index.php?detail_keyword=\(self.keyword!)&detail_type=\(self.type!)&detail_id=\(self.id!)"
        
        //let testUrl = "http://qifanw2-env.us-west-2.elasticbeanstalk.com/index.php?detail_keyword=spacex&detail_type=page&detail_id=353851465130"
        if self.type != "event"{
            Alamofire.request(searchUrl).responseJSON { response in
                if((response.result.value) != nil) {
                    self.data = JSON(response.result.value!)
                    self.AlbumsTable.reloadData()
                    if self.data!["albums"] == JSON.null {
                        self.AlbumsNoData.textAlignment = NSTextAlignment.center
                        self.AlbumsNoData.text = "No data found."
                    }
                }
            }
        }else{
            self.AlbumsNoData.textAlignment = NSTextAlignment.center
            self.AlbumsNoData.text = "No data found."
        }
        SwiftSpinner.hide()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ResultButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*******************************Table Content*******************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if((self.data) != nil){
            return (self.data?["albums"].count)!
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? AlbumsTableViewCell
        if((self.data) != nil){
            let imgUrl1 = self.data!["albums"][indexPath.row]["photos"][0]["picture"].url
            let imgUrl2 = self.data!["albums"][indexPath.row]["photos"][1]["picture"].url

            if(imgUrl1 != nil){
                let imgData1 = try? Data(contentsOf: imgUrl1!)
                cell?.AP1.image = UIImage(data: imgData1!)
                cell?.AP1.accessibilityIdentifier = "yes"
            }else{
                cell?.AP1.image = UIImage()
                cell?.AP1.accessibilityIdentifier = "no"
            }
            if(imgUrl2 != nil){
                let imgData2 = try? Data(contentsOf: imgUrl2!)
                cell?.AP2.image = UIImage(data: imgData2!)
                cell?.AP2.accessibilityIdentifier = "yes"
            }else{
                cell?.AP2.image = UIImage()
               cell?.AP2.accessibilityIdentifier = "no"
            }
            
            cell?.AlbumsName.text = self.data?["albums"][indexPath.row]["name"].string!
        }else{cell?.AlbumsName.text = ""}
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            let tmpCell = tableView.cellForRow(at: indexPath) as! AlbumsTableViewCell
            if tmpCell.AP1.accessibilityIdentifier == "yes"{
                AlbumsTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
            }
            //AlbumsTable.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumsTableViewCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumsTableViewCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in AlbumsTable.visibleCells as! [AlbumsTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return AlbumsTableViewCell.twoPicHeight
        } else {
            return AlbumsTableViewCell.defaultHeight
        }
    }
    
    /*******************************Options Share*******************************/
    
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
        //tmpurl = String(describing: self.avatarUrl)
        tmpurl = "\(self.avatarUrl!)"
        //print(tmpurl!)
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
