//
//  TabBarController.swift
//  JabyJob
//
//  Created by DMG swift on 06/01/22.
//

import UIKit

class TabBarController: UITabBarController {
    fileprivate var userChatData = [String:Any]()
    fileprivate var reciverID = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.userData(_:)), name: NSNotification.Name(rawValue: "videoUserData"), object: nil)
    }
    
    @objc func userData(_ notification: NSNotification) {
        userChatData = notification.object as? [String:Any] ?? [:]
//        let id = userChatData["receiver"] as? String ?? ""
        reciverID = userChatData["userID"] as? Int ?? 0
        
//        print(notification.object as? [String:Any])
 
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.firstIndex(of: item)
        
        
        if indexOfTab == 0 {
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: true)
        }
        if  indexOfTab == 2 || indexOfTab == 3 {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC") as! UserTypeVC
          //  vc.navigationControllerUser = self.navigationController!
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: false) {
//                vc.navigation = self.navigationController
                self.selectedIndex = 0
            }
 
        }else if indexOfTab == 1 {
            let storyboard = UIStoryboard(name: "Search", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false) {
//                vc.navigation = self.navigationController
                self.selectedIndex = 0
            }
//            self.present(vc, animated: false, completion: nil)
        }
        
        if indexOfTab == 4 {

            if reciverID != UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0 {
            let storyboard = UIStoryboard(name: "ChatVC", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.userChatData = self.userChatData
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false) {
                self.selectedIndex = 0
            }
            
        }else {
            let storyboard = UIStoryboard(name: "ChatVC", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.userChatData = self.userChatData
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false) {
                self.selectedIndex = 0
            }
        }
        }
        
//        else if indexOfTab == 3 {
//
////            self.tabBarController?.selectedIndex = 0
//            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//
//            let transition = CATransition.init()
//            transition.duration = 0.01
//            transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
//            transition.type = .moveIn
//            transition.subtype = .fromLeft
////            vc.modalPresentationStyle = .overCurrentContext
//
//            self.view.layer.add(transition, forKey: nil)
//                        vc.modalPresentationStyle = .overCurrentContext
//
//                        present(vc, animated: false) {
//                            vc.navigation = self.navigationController
//                            self.selectedIndex = 0
//
//                        }
//        }
    }
    
}


extension CATransition {

//New viewController will appear from left side of screen.
func popFromLeft() -> CATransition {
    self.duration = 0.1 //set the duration to whatever you'd like.
    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    self.type = CATransitionType.reveal
    self.subtype = CATransitionSubtype.fromLeft
    return self
   }
}






////
////  TabBarController.swift
////  JabyJob
////
////  Created by DMG swift on 06/01/22.
////
//
//import UIKit
//
//class TabBarController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
//
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let indexOfTab = tabBar.items?.firstIndex(of: item)
//        if  indexOfTab == 2 {
//            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "UserTypeVC")
//
//                    vc.modalPresentationStyle = .overFullScreen
//            present(vc, animated: false) {
////                vc.navigation = self.navigationController
//                self.selectedIndex = 0
//            }
//
//        }else if indexOfTab == 1 {
//            let storyboard = UIStoryboard(name: "Search", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! SearchVC
//            vc.modalPresentationStyle = .overCurrentContext
//            present(vc, animated: false) {
////                vc.navigation = self.navigationController
//                self.selectedIndex = 0
//            }
////            self.present(vc, animated: false, completion: nil)
//        }
//        else if indexOfTab == 3 {
//
////            self.tabBarController?.selectedIndex = 0
//            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//
//            let transition = CATransition.init()
//            transition.duration = 0.01
//            transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
//            transition.type = .moveIn
//            transition.subtype = .fromLeft
////            vc.modalPresentationStyle = .overCurrentContext
//
//            self.view.layer.add(transition, forKey: nil)
//                        vc.modalPresentationStyle = .overCurrentContext
//
//                        present(vc, animated: false) {
//                            vc.navigation = self.navigationController
//                            self.selectedIndex = 0
//
//                        }
//        }
//    }
//
//}
//
//
//extension CATransition {
//
////New viewController will appear from bottom of screen.
//func segueFromBottom() -> CATransition {
//    self.duration = 0.375 //set the duration to whatever you'd like.
//    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    self.type = CATransitionType.moveIn
//    self.subtype = CATransitionSubtype.fromTop
//    return self
//}
////New viewController will appear from top of screen.
//func segueFromTop() -> CATransition {
//    self.duration = 0.375 //set the duration to whatever you'd like.
//    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    self.type = CATransitionType.moveIn
//    self.subtype = CATransitionSubtype.fromBottom
//    return self
//}
// //New viewController will appear from left side of screen.
//func segueFromLeft() -> CATransition {
//    self.duration = 0.1 //set the duration to whatever you'd like.
//    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    self.type = CATransitionType.moveIn
//    self.subtype = CATransitionSubtype.fromLeft
//    return self
//}
////New viewController will pop from right side of screen.
//func popFromRight() -> CATransition {
//    self.duration = 0.1 //set the duration to whatever you'd like.
//    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    self.type = CATransitionType.reveal
//    self.subtype = CATransitionSubtype.fromRight
//    return self
//}
////New viewController will appear from left side of screen.
//func popFromLeft() -> CATransition {
//    self.duration = 0.1 //set the duration to whatever you'd like.
//    self.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
//    self.type = CATransitionType.reveal
//    self.subtype = CATransitionSubtype.fromLeft
//    return self
//   }
//}
