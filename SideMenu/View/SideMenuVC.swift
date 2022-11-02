//
//  SideMenu_VC.swift
//  Demo-push
//
//  Created by Arkamac1 on 10/01/22.
//

import UIKit
import SDWebImage
import TTGSnackbar
var paymentTitle = ""
class SideMenuVC: BaseViewController {
    var MenuList = ["Saved","Notification","Subscription Plan","Privacy Policy","Terms & Conditions","Support","Chat"]
    var images =   ["bookmark","notifications","subcs","group-2353","file-text-1","headphones","chatIcon"]
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var Top_Profileview: UIView!
    @IBOutlet weak var Btn_EditProfile: UIButton!
    @IBOutlet weak var Btn_Free: UIButton!
    @IBOutlet weak var Tbl_Menu: UITableView!
    @IBOutlet weak var SlideMenu_View: UIView!
    
    @IBOutlet weak var lblUserEmail: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    var navigation:UINavigationController?
    var index = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        SlideMenu_View.isHidden = false
        Btn_EditProfile.layer.cornerRadius = 4
        Btn_Free.layer.cornerRadius = 4
        Top_Profileview.DropShadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.gray, radius: 3.0, opacity: 0.50)
        self.Top_Profileview.RoundCorner([.layerMaxXMaxYCorner, .layerMinXMaxYCorner], radius: 50.0, borderColor: UIColor.clear, borderWidth: 0)
        let tapView = UITapGestureRecognizer(target: self, action: #selector(didTapDismis))
        self.emptyView.addGestureRecognizer(tapView)
//        isTapOnSideMenu = true
        self.userProfile()
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: false)
        Btn_Free.addTarget(self, action: #selector(didTapBuyPlan(_:)), for: .touchUpInside)
    }
    
    @objc func didTapBuyPlan(_ sender:UIButton){
        
        if Btn_Free.titleLabel?.text == " Buy plan " {
            let storyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "FreeTrialVC") as! FreeTrialVC
            vc.isFrom = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
        }
    }
    
    @objc func didTapDismis(){
        dismissDetail()
    }
    
    func userProfile(){
        let userToken1 = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        ApiClass().getUserProfile(view: self.view, inputUrl:  baseUrl+"profile", parameters: [:], header: userToken1) { result in
            let dict = result as? [String:Any]
        
            let data = dict?["data"] as? JsonDict
            let user = data?["user"] as? JsonDict
            if user?["is_notification"] as? Int ?? 0 == 1 {
                self.index = 1
            }else {
                self.index = 0
            }
            if dict?["status"] as? Int ?? 0 == 1 {
                let subscriptionDeaitls = dict?["subscription_details"] as? JsonDict
                
                let paymentDetails = subscriptionDeaitls?["sub_details"] as? [[String:Any]]
               
                if paymentDetails?.count ?? 0 > 0 {
                    if paymentDetails?[0]["title"] as? String ?? "" == "" {
                        payment = false
                        self.Btn_Free.setTitle(" Free ", for: .normal)
                    }else {
                        payment = true
                    self.Btn_Free.setTitle(" " + (paymentDetails?[0]["title"] as? String ?? "") + " ", for: .normal)
                        paymentTitle = paymentDetails?[0]["title"] as? String ?? ""
                    }
                }else {
                    payment = false
                    self.Btn_Free.setTitle(" Buy plan ", for: .normal)
                }
                
                self.clearUserData()
                UserDefaults.standard.set(1, forKey: "UserLogin")
                UserDefaults.standard.set(dict!, forKey: "userData")
                self.Tbl_Menu.reloadData()
            }
        }
    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.lblUserName.text = userData["full_name"] as? String ?? ""
        self.lblUserEmail.text = userData["email"] as? String ?? ""
        var newLink = self.userData["image"] as? String ?? ""
        newLink = newLink.replacingOccurrences(of: " ", with: "%20")
        
        self.userImg.downloadImage(url: newLink)

        
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)


    }
    @objc func methodOfReceivedNotification(notification: Notification) {
        
        print(notification)
        
        let image = notification.userInfo as? [String:Any]
        let userImage = image?["userImage"] as? UIImage
        self.userImg.image = userImage
    }

    @IBAction func didTapLogout(_ sender: Any) {
//        ApiClass().isUserLogout = false
        ApiClass().logoutApi(view: self.view, inputUrl:  baseUrl+"logout", parameters: [:], header: self.userToken) {[weak self] result in
            print(result)
            payment = false
            self?.clearLogoutUserData()
        }
        
    }
    
    @IBAction func btnslide(_ sender: UIButton) {
        let vC = SlideMenu_View
        transitionVc(vc: vC!, duration: 0.5, type: .fromLeft)
        SlideMenu_View.isHidden = false

    }
    
    @IBAction func Btn_CloseSlideMenu(_ sender: UIButton) {
    dismissDetail()
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        let objToBeSent = true
        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
        dismiss(animated: false)
//        SlideMenu_View.isHidden = true

       }
    @IBAction func didTapProfile(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "EditProfile", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "EditProfileVC") as! EditProfileVC
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
//        self.navigation?.pushViewController(vc, animated: true)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
    
}
extension SideMenuVC: UITableViewDelegate,UITableViewDataSource{
    
    @objc func didTapSwitchBtn(_ sender:UIButton){
        
//        sender.isSelected = !sender.isSelected
        
        if index == 1 {
           
            let parmas = ["isNotification":1] as JsonDict
            ApiClass().notificationsOnOff(view: self.view, inputUrl: baseUrl+"enable-notification", parameters: parmas, header: self.userToken) { result in
                print(result)
                let dict = result as? JsonDict
                self.index = 0
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
            }
        }else {
            
            let parmas = ["isNotification":0] as JsonDict
            ApiClass().notificationsOnOff(view: self.view, inputUrl: baseUrl+"enable-notification", parameters: parmas, header: self.userToken) { result in
                let dict = result as? JsonDict
                let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
                snackbar.show()
                self.index = 1
                print(result)
            }
        }
        self.Tbl_Menu.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MenuListCell
        if indexPath.row == 1{
            cell.Btn_Switch.isHidden = false
            cell.Btn_Switch.addTarget(self, action: #selector(didTapSwitchBtn(_:)), for: .touchUpInside)
        
            if index == 0 {
                index = 1
                cell.Btn_Switch.setBackgroundImage(UIImage(named: "switch-1"), for: .normal)
            }else {
                index = 0
                cell.Btn_Switch.setBackgroundImage(UIImage(named: "Switch"), for: .normal)
            }
        }
        else{
            cell.Btn_Switch.isHidden = true

        }
        cell.lbl_MenuName.text = MenuList[indexPath.row]
        cell.imglist.image = UIImage(named: images[indexPath.row])
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let transition = CATransition()
//        transition.duration = 0.25
//        transition.type = CATransitionType.moveIn
//        transition.subtype = CATransitionSubtype.fromRight
//        self.view.window!.layer.add(transition, forKey: kCATransition)
//        dismiss(animated: false)
        
        if indexPath.row == 0 {
            
            let storyboard = UIStoryboard(name: "Save", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SaveVC") as! SaveVC
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
         //   self.navigation?.pushViewController(vc, animated: true)
            
        }else if indexPath.row == 5 {
            let storyboard = UIStoryboard(name: "Support", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "Support") 
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
//            self.navigation?.pushViewController(vc, animated: true)
        }

        if indexPath.row == 1 {

            let storyboard = UIStoryboard(name: "Notification", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "NotificationVC")
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
//            self.navigation?.pushViewController(vc, animated: true)
        }
        if indexPath.row == 2 {

            let storyboard = UIStoryboard(name: "Subscriptions", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "FreeTrialVC") as! FreeTrialVC
            vc.isFrom = true
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
//            self.navigation?.pushViewController(vc, animated: true)
        }
        
        if indexPath.row == 6 {

            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
             let vc = storyboard.instantiateViewController(withIdentifier: "ChatListVC") as! ChatListVC
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)

        }
        
        if indexPath.row == 3 {
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PdfViewerVC") as! PdfViewerVC
            vc.title1 = "Privacy & Policy"
            vc.pdfViewUrl = "http://jabyjobs.arkasoftwares.in/privacy-policy.html"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
        }else if indexPath.row == 4{
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "PdfViewerVC") as! PdfViewerVC
            vc.title1 = "Terms & Conditions"
            vc.pdfViewUrl = "http://jabyjobs.arkasoftwares.in/terms-&-conditions.html"
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            dismiss(animated: false)
        }
        
        
//        self.dismissDetail()
    }
}
extension UIView {
  func DropShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
    layer.masksToBounds = false
    layer.shadowOffset = offset
    layer.shadowColor = color.cgColor
    layer.shadowRadius = radius
    layer.shadowOpacity = opacity
    let backgroundCGColor = backgroundColor?.cgColor
    backgroundColor = nil
    layer.backgroundColor = backgroundCGColor
  }
}

extension UIView {

  func RoundCorner(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
      self.layer.maskedCorners = corners
      self.layer.cornerRadius = radius
      self.layer.borderWidth = borderWidth
      self.layer.borderColor = borderColor.cgColor
   
  }

}

extension UIViewController {
func transitionVc(vc: UIView, duration: CFTimeInterval, type: CATransitionSubtype) {
    let customVcTransition = vc
    let transition = CATransition()
    transition.duration = duration
    transition.type = CATransitionType.push
    transition.subtype = type
    transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
    view.window!.layer.add(transition, forKey: kCATransition)
   // present(customVcTransition, animated: false, completion: nil)
}}

extension UIImageView{
    func downloadImage(url:String){
      //remove space if a url contains.
        let stringWithoutWhitespace = url.replacingOccurrences(of: " ", with: "%20", options: .regularExpression)
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_setImage(with: URL(string: stringWithoutWhitespace), placeholderImage:UIImage(named: "avatar"))
    }
}
