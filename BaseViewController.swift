//
//  BaseViewController.swift
//  JabyJob
//
//  Created by DMG swift on 05/01/22.
//

import UIKit
import SDWebImage

class BaseViewController: UIViewController {
    var logeedInUsessrData = [String:Any]()
    var userData = [String:Any]()
    var userToken = String()
    var countryData = [Int]()
    var userRoll = Int()
    var userLoginInOrNot = Int()
    var Id = Int()
   
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.logeedInUsessrData = userDataShow(userdata: "userData")
        let data = logeedInUsessrData["data"] as? [String:Any] ?? [:]
        
        self.countryData = data["country"] as? [Int] ?? []
        self.userData = data["user"] as? [String:Any] ?? [:]
        self.Id = userData["id"] as? Int ?? 0
        let logInUserData = data["user"] as? [String:Any]
        
        
        
        if logInUserData?.count ?? 0 > 0 {
            self.userRoll = logInUserData?["role_id"] as? Int ?? 0
            UserDefaults.standard.set(logInUserData?["role_id"] as? Int ?? 0, forKey: "role_id")
          
            UserDefaults.standard.set(logInUserData?["id"] as? Int ?? 0, forKey: "user_id")
        }else {
            self.userRoll = data["role_id"] as? Int ?? 0
            UserDefaults.standard.set(data["role_id"] as? Int ?? 0, forKey: "role_id")
          
            UserDefaults.standard.set(data["id"] as? Int ?? 0, forKey: "user_id")
        }
        
        
       
        self.userLoginInOrNot = UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0
        self.userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
       
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

 
    // MARK: - Button Actions

    @IBAction func didTapRootBack(_ sender:UIButton) {
//        self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
    }
    
    @IBAction func didTapBack(_ sender:UIButton) {
       // isInital = true
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func didTapDismiss(_ sender:UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didtapSkip(_ sender:UIButton) {
        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
        
    }
    
}
extension UIViewController {
    var appDelegate: AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
   }
    
    func clearUserData(){
       UserDefaults.standard.removeObject(forKey: "UserLogin")
       UserDefaults.standard.removeObject(forKey: "userData")
        
    }

    
    func clearLogoutUserData(){
        UserDefaults.standard.removeObject(forKey: "userData")
        UserDefaults.standard.set(0, forKey: "UserLogin")
        UserDefaults.standard.removeObject(forKey: "userData")
        UserDefaults.standard.removeObject(forKey: "userToken")
        appDelegate.setRootToLogin(controllerVC: TabBarController(), storyBoard: "TabBar", identifire: "TabBarController")
    }
    
}



