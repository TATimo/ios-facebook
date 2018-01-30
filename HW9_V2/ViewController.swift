//
//  ViewController.swift
//  HW9_V2
//
//  Created by Andrew Wang on 2017/4/15.
//  Copyright © 2017年 Apple Inc. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Foundation
import EasyToast
import SwiftSpinner
import CoreLocation

class ViewController: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {
    var usrInput: String?
    var lat: Double?
    var lng: Double?
    var data: JSON?
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MenuButton.target = revealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        /*UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "keyword")
        UserDefaults.standard.removeObject(forKey: "image")
        UserDefaults.standard.removeObject(forKey: "user")
        UserDefaults.standard.removeObject(forKey: "page")
        UserDefaults.standard.removeObject(forKey: "place")
        UserDefaults.standard.removeObject(forKey: "event")
        UserDefaults.standard.removeObject(forKey: "group")*/
        
        /*var testout = UserDefaults.standard.dictionary(forKey: "image")?["353851465130"]
        testout = URL(string: testout as! String)
        print(testout!)*/
        
        //print((UserDefaults.standard.array(forKey: "page"))?.count)
                
        if UserDefaults.standard.array(forKey: "user") == nil{
            print("default nil")
            var tmpdic1 = [String: String]()
            tmpdic1 = [:]
            var tmpdic2 = [String: String]()
            tmpdic2 = [:]
            var tmparray: [String] = []
            UserDefaults.standard.set(tmpdic1, forKey: "name")
            UserDefaults.standard.set(tmpdic1, forKey: "keyword")
            UserDefaults.standard.set(tmpdic2, forKey: "image")
            UserDefaults.standard.set(tmparray, forKey: "user")
            UserDefaults.standard.set(tmparray, forKey: "page")
            UserDefaults.standard.set(tmparray, forKey: "place")
            UserDefaults.standard.set(tmparray, forKey: "event")
            UserDefaults.standard.set(tmparray, forKey: "group")
            print("local Storage Establish successfully...")
        }else{
            print("default Allset")
        }
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*******************************Location*******************************/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        self.lat = location.coordinate.latitude
        self.lng = location.coordinate.longitude
        /*print(type(of: location.coordinate.latitude))
        print(location.coordinate.longitude)*/
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: " + (error.localizedDescription))
    }

    /*******************************Button*******************************/
    
    @IBOutlet weak var txtinput: UITextField!

    @IBAction func ClearButton(_ sender: Any) {
        txtinput.text = ""
    }
    
    @IBAction func SearchButton(_ sender: Any) {
        txtinput.resignFirstResponder()
        usrInput = txtinput.text!.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: " ", with: "%20")
        //usrInput = txtinput.text!
        print(usrInput!)
        if (usrInput != nil && usrInput != "") {
            self.performSegue(withIdentifier: "SearchSucceed", sender: nil)
        }else{
            self.view.toastBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.view.toastTextColor = UIColor.white
            self.view.showToast("Enter a valid query!", position: .bottom, popTime: 2, dismissOnTap: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        txtinput.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
     /*******************************Menu Button*******************************/
    
    @IBOutlet weak var MenuButton: UIBarButtonItem!
    
    /*******************************Table Content*******************************/
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "SearchSucceed"){
            let resultScene = segue.destination as! TotalViewController
            resultScene.keyword = self.usrInput
            resultScene.mode = "search"
            if (self.lng != nil && self.lat != nil) {
                resultScene.lat = self.lat
                resultScene.lng = self.lng
            }
            SwiftSpinner.show("Loading data...")
        }
    }
}

