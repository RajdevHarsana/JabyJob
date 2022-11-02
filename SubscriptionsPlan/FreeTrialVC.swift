//
//  FreeTrialVC.swift
//  Demo-push
//
//  Created by Arkamac1 on 07/01/22.
//

import UIKit

class FreeTrialVC: BaseViewController {
    @IBOutlet weak var img0: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    @IBOutlet weak var Free_TrialView: UIView!
    @IBOutlet weak var Monthly_View: UIView!
    @IBOutlet weak var HalfYearly_View: UIView!
    @IBOutlet weak var Quartly_View: UIView!
    @IBOutlet weak var Yearly_View: UIView!
    @IBOutlet weak var btn_Freetrial: UIButton!
    @IBOutlet weak var lblOneMonth: UILabel!
    @IBOutlet weak var lblThreeMonth: UILabel!
    @IBOutlet weak var lblSixMonth: UILabel!
    @IBOutlet weak var lbltwelveMonth: UILabel!
    @IBOutlet weak var btnPlan: UIButton!
    var freeTrailModalView = FreeTrialViewModal()
    var delegate: Subscription?
    var selectTitle = String()
    var subcriotionTitle = String()
    var isFromProfile = false
    
    @IBOutlet weak var lblFreeDays: UILabel!
    @IBOutlet weak var lblFreeTitle: UILabel!
    
    @IBOutlet weak var lblMonthDays: UILabel!
    @IBOutlet weak var lblMonthTitle: UILabel!
    
    @IBOutlet weak var lbl3MonthDays: UILabel!
    @IBOutlet weak var lbl3MonthTitle: UILabel!
    
    @IBOutlet weak var lbl6MonthDays: UILabel!
    @IBOutlet weak var lbl6MonthTitle: UILabel!
    
    @IBOutlet weak var lbl12MonthDays: UILabel!
    @IBOutlet weak var lbl12MonthTitle: UILabel!
    var isFrom  = Bool()
    var isRegister = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        freeTrailModalView.VC = self
        freeTrailModalView.planAPi()
        freeTrailModalView.initialUIsetUp()
        
    }
    
    func setRootController(){
        self.appDelegate.setRootToLogin(controllerVC: IntroVC(), storyBoard: "TabBar", identifire: "AfterLoingTabBarController")
    }
    
    @IBAction func didTapback(_ sender:UIButton){
        
        if isRegister == true {
            setRootController()
        }else if isFrom == true {
            self.dismiss(animated: true) {
                let objToBeSent = true
                NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
            }
            
//            self.dismiss(animated: true, completion: nil)
        }else {
//            delegate?.subcriptionPlanStatus(value: 1, title: selectTitle, subcriptionTitle: subcriotionTitle)
            if isFromTabBar == true {
                self.navigationController?.popViewController(animated: true)
            }else {
                setRootController()
            }
           
//
        }
        
    }
    @IBAction func didTapPlan(_ sender:UIButton){
        
        if freeTrailModalView.isTapOnFreeTrail == true {
            freeTrailModalView.isTapOnFreeTrail = false
            freeTrailModalView.purchseFreetrail(palnId: freeTrailModalView.freeTrailPlanId)
        }else {
            freeTrailModalView.nagadPaymnetAPI(palnId: freeTrailModalView.palanID)
        }
        
       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension UIView {
  func viewshadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
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

  func roundCorners(_ corners: CACornerMask, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
      self.layer.maskedCorners = corners
      self.layer.cornerRadius = radius
      self.layer.borderWidth = borderWidth
      self.layer.borderColor = borderColor.cgColor
   
  }

}

