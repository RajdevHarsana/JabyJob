

//
//  AfterLoingTabBarController.swift
//  JabyJob
//
//  Created by DMG swift on 19/01/22.
//

import UIKit
var isFromTabBar = false
class AfterLoingTabBarController: UITabBarController {
    fileprivate var userChatData = [String:Any]()
    fileprivate var reciverId = Int()
    
    @objc func userData(_ notification: NSNotification) {
        userChatData = notification.object as? [String:Any] ?? [:]
//        let id = userChatData["receiver"] as? String ?? ""
        reciverId = userChatData["receiver"] as? Int ?? 0
        
//        if  let arrayOfTabBarItems = self.tabBar.items as AnyObject as? NSArray,let tabBarItem = arrayOfTabBarItems[4] as? UITabBarItem {
//
//            if reciverId != UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0 {
//                self.tabBarController?.tabBar.isUserInteractionEnabled = true
//            }else {
//                self.tabBarController?.tabBar.isUserInteractionEnabled = false
//            }
//
//            }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        print(notification)
        let image = notification.userInfo as? [String:Any]
        let userImage = image?["userImage"] as? UIImage
        
        let barImage: UIImage = userImage!.squareMyImage().resizeMyImage(newWidth: 40).roundMyImage.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].image = barImage
        self.tabBar.items?[2].badgeValue = "+"
        
//        self.userImg.image = userImage
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.userData(_:)), name: NSNotification.Name(rawValue: "videoUserData"), object: nil)
        
        
        for tabBarButton in self.tabBar.subviews{
                for badgeView in tabBarButton.subviews{
                var className=NSStringFromClass(badgeView.classForCoder)
                    if  className == "_UIBadgeView"
                    {
                        badgeView.layer.transform = CATransform3DIdentity
                        badgeView.layer.transform = CATransform3DMakeTranslation(-6.0, 1.0, 1.0)
                    }
                }
            }
    }
    let customTabBarView: UIView = {

            let view = UIView(frame: .zero)

            view.backgroundColor = .white
            view.layer.cornerRadius = 20
            view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            view.clipsToBounds = true

            view.layer.masksToBounds = false
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowOffset = CGSize(width: 0, height: -8.0)
            view.layer.shadowOpacity = 0.12
            view.layer.shadowRadius = 10.0
            return view
        }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    
        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        if UserDefaults.standard.value(forKey: "UserLogin") as? Int ?? 0 == 1 {
            ApiClass().getUserTabBarProfile(view: self.view, inputUrl:  baseUrl+"profile", parameters: [:], header: userToken) { result in
                let dict = result as? [String:Any]
         
                if dict?["status"] as? Int ?? 0 == 1 {
                    
                    
                    let subscriptionDeaitls = dict?["subscription_details"] as? JsonDict
                    
                    let paymentDetails = subscriptionDeaitls?["sub_details"] as? [[String:Any]]
                   
                    if paymentDetails?.count ?? 0 > 0 {
                        if paymentDetails?[0]["title"] as? String ?? "" == "" {
                            payment = false
                        }else {
                            payment = true
                            paymentTitle = paymentDetails?[0]["title"] as? String ?? ""
                        }
                    }
                    
                    let data1 = dict?["data"] as? [String:Any]
                    let userData = data1?["user"] as? [String:Any]
                    let image1 = userData?["image"] as? String ?? ""
                    guard let url = URL(string: image1) else { return }
                         let data = try! Data(contentsOf: url)
                         let image = UIImage(data: data)
                    
                    
                    if image == nil {
                        let image1 = #imageLiteral(resourceName: "avatar")
                        let image = UIImage(data: image1.pngData()!)
                        let barImage: UIImage = image!.squareMyImage().resizeMyImage(newWidth: 40).roundMyImage.withRenderingMode(.alwaysOriginal)
                        self.tabBar.items?[2].image = barImage
                        self.tabBar.items?[2].badgeValue = "+"
                    }else {
                        let barImage: UIImage = image!.squareMyImage().resizeMyImage(newWidth: 40).roundMyImage.withRenderingMode(.alwaysOriginal)
                        self.tabBar.items?[2].image = barImage
                        self.tabBar.items?[2].badgeValue = "+"
                    }
                    for tabBarButton in self.tabBar.subviews{
                            for badgeView in tabBarButton.subviews{
                            var className=NSStringFromClass(badgeView.classForCoder)
                                if  className == "_UIBadgeView"
                                {
                                    badgeView.layer.transform = CATransform3DIdentity
                                    badgeView.layer.transform = CATransform3DMakeTranslation(-6.0, 1.0, 1.0)
                                }
                            }
                        }
                }
            }
        }
    }
    
    
    
    
//    func repositionBadge(tab: Int){
////        self.tabBarController?.tabBar.subviews[tab].subviews
//        for badgeView in self.tabBarController?.tabBar.subviews[tab].subviews {
//            if NSStringFromClass(badgeView.classForCoder) == "_UIBadgeView" {
//                badgeView.layer.transform = CATransform3DIdentity
//                badgeView.layer.transform = CATransform3DMakeTranslation(-17.0, 1.0, 1.0)
//            }
//        }
//
//    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent

    }
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let indexOfTab = tabBar.items?.firstIndex(of: item)
        if indexOfTab == 2 {
            isFromTabBar = true
        }
        
        if indexOfTab == 0 {
            NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: true)
        }
        

        if indexOfTab == 4 {
           
            if reciverId != UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0{
            let storyboard = UIStoryboard(name: "ChatVC", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
            vc.userChatData = self.userChatData
            vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false) {
//                vc.navigation = self.navigationController
                self.selectedIndex = 0
            }
            }else {
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Alert", message: "You can't Chat with your own?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                            case .default:
                            print("default")
                            self.selectedIndex = 0
                            case .cancel:
                            print("cancel")
                            self.selectedIndex = 0
                            case .destructive:
                            print("destructive")
                            self.selectedIndex = 0
                            
                        }
                    }))
                    
                    alert.modalPresentationStyle = .overCurrentContext
                    self.selectedIndex = 0
                    self.present(alert, animated: false) {
                        self.selectedIndex = 0
                    }
                }
            }
       }
        
        if indexOfTab == 3 {
           
//            self.tabBarController?.selectedIndex = 0
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC

            let transition = CATransition.init()
            transition.duration = 0.3
            transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
            transition.type = .moveIn
            transition.subtype = .fromLeft
            vc.modalPresentationStyle = .overCurrentContext
           
            self.view.layer.add(transition, forKey: nil)
                        vc.modalPresentationStyle = .overCurrentContext
            present(vc, animated: false) {
                vc.navigation = self.navigationController
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
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    


}


////
////  AfterLoingTabBarController.swift
////  JabyJob
////
////  Created by DMG swift on 19/01/22.
////
//
//import UIKit
//
//class AfterLoingTabBarController: UITabBarController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//
//    }
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let indexOfTab = tabBar.items?.firstIndex(of: item)
//        if indexOfTab == 3 {
//
////            self.tabBarController?.selectedIndex = 0
//            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "SideMenuVC") as! SideMenuVC
//
//            let transition = CATransition.init()
//            transition.duration = 0.3
//            transition.timingFunction = CAMediaTimingFunction.init(name: .easeInEaseOut)
//            transition.type = .moveIn
//            transition.subtype = .fromLeft
//            vc.modalPresentationStyle = .overCurrentContext
//
//            self.view.layer.add(transition, forKey: nil)
//                        vc.modalPresentationStyle = .overCurrentContext
//            present(vc, animated: false) {
//                vc.navigation = self.navigationController
//                            self.selectedIndex = 0
//                        }
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
//    }
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
extension UIImage{

    var roundMyImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(self.size, false, 1)
        UIBezierPath(
            roundedRect: rect,
            cornerRadius: self.size.height
            ).addClip()
        self.draw(in: rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    func resizeMyImage(newWidth: CGFloat) -> UIImage {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))

        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    func squareMyImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: self.size.width, height: self.size.width))

        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.width))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
}



extension UIImage {
    func toData (options: NSDictionary, type: CFString) -> Data? {
        guard let cgImage = cgImage else { return nil }
        return autoreleasepool { () -> Data? in
            let data = NSMutableData()
            guard let imageDestination = CGImageDestinationCreateWithData(data as CFMutableData, type, 1, nil) else { return nil }
            CGImageDestinationAddImage(imageDestination, cgImage, options)
            CGImageDestinationFinalize(imageDestination)
            return data as Data
        }
    }
}
