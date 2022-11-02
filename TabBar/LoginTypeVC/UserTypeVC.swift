//
//  UserTypeVC.swift
//  JabyJob
//
//  Created by DMG swift on 07/01/22.
//

import UIKit

class UserTypeVC: UIViewController {
    
    @IBOutlet weak var jobSeekerView: UIView!
    @IBOutlet weak var interJobSeekerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8) //view only black coloured transparent
        jobSeekerView.roundCorners([.topLeft, .bottomLeft], radius: 10)
        interJobSeekerView.roundCorners([.topLeft, .bottomLeft], radius: 10)
       
        // Do any additional setup after loading the view.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

 
    // MARK: - Button Actions
     
    @IBAction func didTapJobSeeker(_ sender:UIButton) {
//        appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "Intro", identifire: "IntroVC")
//        print("userIntroValue",UserData.value(forKey: "introJob") ?? false)
        
        if UserDefaultData.value(forKey: "introJob") as? Bool == false || UserDefaultData.value(forKey: "introJob") == nil {
            appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "Intro", identifire: "IntroVC")
            UserDefaultData.set(false, forKey: "introJob")
        }else {
            appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "SignUp", identifire: "SignUpVC")
        }
        UserDefaultData.set(2, forKey: "user")
        
        let objToBeSent = false
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
    }
    
    @IBAction func didTapInterJobSeeker(_ sender:UIButton) {
       
        if UserDefaultData.value(forKey: "introIntrJob") as? Bool == false || UserDefaultData.value(forKey: "introIntrJob") == nil{
            appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "Intro", identifire: "IntroVC")
            UserDefaultData.set(false, forKey: "introIntrJob")

        }else {
            appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "SignUp", identifire: "SignUpVC")
        }
        
        
        
        UserDefaultData.set(3, forKey: "user")
        
        let objToBeSent = false
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
//       UserData.set(false, forKey: "introIntrJob")
    }
    @IBAction func didTapDismiss(_ sender:UIButton) {
        self.dismiss(animated: true) {
            let objToBeSent = true
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
          
        }
        
    }
}
extension UIView {
    func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}
