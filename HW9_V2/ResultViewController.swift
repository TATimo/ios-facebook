//
//  ResultViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/16.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftSpinner

class ResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var keyword: String?
    var type: String?
    var id: String?
    var mode: String?
    var data: JSON?
    var avatarUrl: URL?
    var lat: Double?
    var lng: Double?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var PButton: UIButton!
    @IBOutlet weak var NButton: UIButton!
    
    @IBAction func PreviousButton(_ sender: Any) {
        if(self.mode == "search"){
            Alamofire.request(self.data!["paging"]["previous"].string!).responseJSON { response in
                if((response.result.value) != nil) {
                    self.data = JSON(response.result.value!)
                    /*****************************PNButtons*****************************/
                    if self.data!["paging"]["next"] != JSON.null {
                        Alamofire.request(self.data!["paging"]["next"].string!).responseJSON { newresponse in
                            if((newresponse.result.value) != nil) {
                                if(JSON(newresponse.result.value!)["data"].count != 0){
                                    self.NButton.isEnabled = true
                                }else {self.NButton.isEnabled = false}
                            }else {self.NButton.isEnabled = false}
                        }
                    }else {
                        self.NButton.isEnabled = false
                    }
                    
                    if self.data!["paging"]["previous"] != JSON.null {
                        Alamofire.request(self.data!["paging"]["previous"].string!).responseJSON { newresponse in
                            if((newresponse.result.value) != nil) {
                                if(JSON(newresponse.result.value!)["data"].count != 0){
                                    self.PButton.isEnabled = true
                                }else {self.PButton.isEnabled = false}
                            }else {self.PButton.isEnabled = false}
                        }
                    }else {
                        self.PButton.isEnabled = false
                    }
                    /*****************************PNButtons*****************************/
                    self.tableView.reloadData()
                }
            }
        }else{
            self.PButton.isEnabled = false
            self.tableView.reloadData()
        }
    }
    
    @IBAction func NextButton(_ sender: Any) {
        if self.mode == "search" {
            Alamofire.request(self.data!["paging"]["next"].string!).responseJSON { response in
                if((response.result.value) != nil) {
                    self.data = JSON(response.result.value!)
                    /*****************************PNButtons*****************************/
                    if self.data!["paging"]["next"] != JSON.null {
                        Alamofire.request(self.data!["paging"]["next"].string!).responseJSON { newresponse in
                            if((newresponse.result.value) != nil) {
                                if(JSON(newresponse.result.value!)["data"].count != 0){
                                    self.NButton.isEnabled = true
                                }else {self.NButton.isEnabled = false}
                            }else {self.NButton.isEnabled = false}
                        }
                    }else {
                        self.NButton.isEnabled = false
                    }
                    
                    if self.data!["paging"]["previous"] != JSON.null {
                        Alamofire.request(self.data!["paging"]["previous"].string!).responseJSON { newresponse in
                            if((newresponse.result.value) != nil) {
                                if(JSON(newresponse.result.value!)["data"].count != 0){
                                    self.PButton.isEnabled = true
                                }else {self.PButton.isEnabled = false}
                            }else {self.PButton.isEnabled = false}
                        }
                    }else {
                        self.PButton.isEnabled = false
                    }
                    /*****************************PNButtons*****************************/
                    self.tableView.reloadData()
                }
            }
        }else{
            self.PButton.isEnabled = false
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        if self.mode == "search" {
            var searchUrl: String?
            if (self.lng != nil && self.lat != nil) {
                searchUrl = "http://qifanw2-env.us-west-2.elasticbeanstalk.com/index.php?keyword=\(self.keyword!)&type=user&lat=\(self.lat!)&lng=\(self.lng!)&limit=10"
            }else{
                searchUrl = "http://qifanw2-env.us-west-2.elasticbeanstalk.com/index.php?keyword=\(self.keyword!)&type=user&limit=10"
            }
            Alamofire.request(searchUrl!).responseJSON { response in
                if((response.result.value) != nil) {
                    self.data = JSON(response.result.value!)
                    /*****************************PNButtons*****************************/
                    if self.data!["paging"]["next"] != JSON.null {
                        Alamofire.request(self.data!["paging"]["next"].string!).responseJSON { newresponse in
                            if((newresponse.result.value) != nil) {
                                if(JSON(newresponse.result.value!)["data"].count != 0){
                                    self.NButton.isEnabled = true
                                }else {self.NButton.isEnabled = false}
                            }else {self.NButton.isEnabled = false}
                        }
                    }else {
                        self.NButton.isEnabled = false
                    }
                    
                    if self.data!["paging"]["previous"] != JSON.null {
                        Alamofire.request(self.data!["paging"]["previous"].string!).responseJSON { newresponse in
                            if((newresponse.result.value) != nil) {
                                if(JSON(newresponse.result.value!)["data"].count != 0){
                                    self.PButton.isEnabled = true
                                }else {self.PButton.isEnabled = false}
                            }else {self.PButton.isEnabled = false}
                        }
                    }else {
                        self.PButton.isEnabled = false
                    }
                    /*****************************PNButtons*****************************/
                    self.tableView.reloadData()
                    SwiftSpinner.hide()
                }else{
                    SwiftSpinner.hide()
                    print(self.keyword!)
                    print("Error Search...")
                }
            }
        }else{
            self.tableView.reloadData()
            SwiftSpinner.hide()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    /*******************************Table Content*******************************/
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mode == "search"{
            if((self.data) != nil){
                return self.data!["data"].count
            }else{
                return 0
            }
        }else{
            return (UserDefaults.standard.array(forKey: "user")?.count)!
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tmparray = [String]()
        var tmpid: String?
        tmparray = UserDefaults.standard.array(forKey: "user") as! [String]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustonCell
        if self.mode == "search"{
            tmpid = self.data!["data"][indexPath.row]["id"].string!
            if((self.data) != nil){
                let tmpName = self.data!["data"][indexPath.row]["name"].string!
                let imgUrl = self.data!["data"][indexPath.row]["picture"]["data"]["url"].url
                let imgData = try? Data(contentsOf: imgUrl!)
                cell?.ResultName.text = tmpName
                cell?.ResultImg.image = UIImage(data: imgData!)
                cell?.FavoritesButton.tag = indexPath.row
                cell?.FavoritesButton.addTarget(self, action: #selector(FavoOperator(_:)), for: UIControlEvents.touchUpInside)
                
                if !tmparray.contains(tmpid!) {
                    cell?.FavoritesButton.setImage(UIImage(named: "empty"), for: UIControlState.normal)
                }else {
                    cell?.FavoritesButton.setImage(UIImage(named: "filled"), for: UIControlState.normal)
                }
            }else{
                cell?.ResultName.text = ""
            }
        }else{
            if(UserDefaults.standard.array(forKey: "user")?.count != 0){
                var tmpid: String?
                var tmpname: String?
                var tmpurl: String?
                var imgUrl: URL?
                tmpid = UserDefaults.standard.array(forKey: "user")?[indexPath.row] as? String
                tmpname = UserDefaults.standard.dictionary(forKey: "name")?[tmpid!] as? String
                tmpurl = UserDefaults.standard.dictionary(forKey: "image")?[tmpid!] as? String
                imgUrl = URL(string: tmpurl!)
                let imgData = try? Data(contentsOf: imgUrl!)
                cell?.ResultName.text = tmpname
                cell?.ResultImg.image = UIImage(data: imgData!)
                /*cell?.FavoritesButton.tag = indexPath.row
                 cell?.FavoritesButton.addTarget(self, action: #selector(FavoOperator(_:)), for: UIControlEvents.touchUpInside)*/
                cell?.FavoritesButton.setImage(UIImage(named: "filled"), for: UIControlState.normal)
            }else {cell?.ResultName.text = ""}
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.mode == "search"){
            self.id = self.data!["data"][indexPath.row]["id"].string!
            self.avatarUrl = self.data!["data"][indexPath.row]["picture"]["data"]["url"].url
        }else{
            var tmpid: String?
            var tmpurl: String?
            var tmpkeyword: String?
            tmpid = UserDefaults.standard.array(forKey: "user")?[indexPath.row] as? String
            tmpurl = UserDefaults.standard.dictionary(forKey: "image")?[tmpid!] as? String
            tmpkeyword = UserDefaults.standard.dictionary(forKey: "keyword")?[tmpid!] as? String
            let imgUrl = URL(string: tmpurl!)
            self.id = tmpid
            self.avatarUrl = imgUrl
            self.keyword = tmpkeyword
        }
        self.type = "user"
        self.performSegue(withIdentifier: "userDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "userDetail"){
            let resultScene = segue.destination as! DetailsViewController
            resultScene.keyword = self.keyword
            resultScene.id = self.id
            resultScene.type = self.type
            resultScene.avatarUrl = self.avatarUrl
        }
    }

    /*******************************Favorites*******************************/
    
    func FavoOperator(_ sender: UIButton) {
        if sender.imageView?.image == UIImage(named: "empty"){
            sender.setImage(UIImage(named: "filled"), for: UIControlState.normal)
        }else{
            sender.setImage(UIImage(named: "empty"), for: UIControlState.normal)
        }
        var tmpid: String?
        var tmpname: String?
        var tmpurl: String?
        tmpid = self.data!["data"][sender.tag]["id"].string!
        tmpname = self.data!["data"][sender.tag]["name"].string!
        tmpurl = self.data!["data"][sender.tag]["picture"]["data"]["url"].string!
        var tmpnamedic = UserDefaults.standard.dictionary(forKey: "name")
        var tmpimagedic = UserDefaults.standard.dictionary(forKey: "image")
        var tmpkeyworddic = UserDefaults.standard.dictionary(forKey: "keyword")
        var tmparray = [String]()
        tmparray = UserDefaults.standard.array(forKey: "user") as! [String]
        if !tmparray.contains(tmpid!){
            /************************* user *************************/
            tmparray.append(tmpid!)
            UserDefaults.standard.set(tmparray, forKey: "user")
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
            tmpnamedic?[tmpid!] = nil
            tmpimagedic?[tmpid!] = nil
            tmpkeyworddic?[tmpid!] = nil
            UserDefaults.standard.set(tmpnamedic, forKey: "name")
            UserDefaults.standard.set(tmpimagedic, forKey: "image")
            UserDefaults.standard.set(tmpkeyworddic, forKey: "keyword")
            /************************* user *************************/
            tmparray = tmparray.filter{$0 != tmpid}
            UserDefaults.standard.set(tmparray, forKey: "user")
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.showToast("Removed from favorites!", position: .bottom, popTime: 2, dismissOnTap: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
}
