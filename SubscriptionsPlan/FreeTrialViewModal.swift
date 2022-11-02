//
//  FreeTrialViewModal.swift
//  JabyJob
//
//  Created by DMG swift on 19/01/22.
//

import Foundation
import UIKit
import TTGSnackbar

class FreeTrialViewModal {
//    weak var VC: SkillsVC?
    weak var VC: FreeTrialVC?
    var planData = [SubscriptionModal]()
    var palanID = Int()
    var UserId = Int()
    var freeTrailPlanId = 1
    var isTapOnFreeTrail = true
    func planAPi(){
        if UserDefaults.standard.value(forKey: "userid") as? Int ?? 0 != 0 {
            UserId = UserDefaults.standard.value(forKey: "userid") as? Int ?? 0
        }else {
            UserId = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
        }
        let param = ["user_id":UserId] as JsonDict
        ApiClass().supcriptionApi(view: (VC?.view)!, BaeUrl: baseUrl+"subscription", paramters: param) { result in
            print(result)
            self.planData.append(result as! SubscriptionModal)
            self.updatePlansUI()
        }
    }
    
    
    func purchseFreetrail(palnId:Int){
        let userid = UserDefaults.standard.value(forKey: "user_id") as? Int ?? 0
//        VC.userde
        let param = ["plan_id":palnId] as JsonDict
        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
        ApiClass().purchaseFreeTrail(view:(VC?.view)!, inputUrl: baseUrl+"free-purchase-plan", parameters: param, header: userToken) { response in
            print(response)
            let dict = response as? JsonDict
            
            let snackbar = TTGSnackbar(message: dict?["message"] as? String ?? "", duration: .short)
            snackbar.show()
            
          if self.VC?.isRegister == true {
              self.VC?.setRootController()
            }else {
                payment = true
                
                if self.VC?.isFromProfile == true {
                    self.VC?.navigationController?.popViewController(animated: true)
                }else {
                    self.VC?.dismiss(animated: true) {
                        let objToBeSent = true
                        NotificationCenter.default.post(name: Notification.Name("stopePlayer"), object: objToBeSent)
                    }
                }
            }
        }
    }
    
    
    func nagadPaymnetAPI(palnId:Int){
        let userToken = UserDefaultData.value(forKey: "userToken") as? String ?? ""
//        VC.userde
        let param = ["plan_id":palnId] as JsonDict
        ApiClass().nagadPaymentgatwayAPi(view:  (VC?.view)!, inputUrl: baseUrl+"create-nagad-url", parameters: param, header: userToken) { resutl in
            print(resutl)
            
            let dict = resutl as? JsonDict
            
            if dict?["data"] as? String ?? "" != "" {
                let storyboard = UIStoryboard(name: "Payment", bundle: nil)
                 let vc = storyboard.instantiateViewController(withIdentifier: "PaymentView") as! PaymentView
                vc.paymentUrl = dict?["data"] as? String ?? ""
                vc.planID = palnId
                vc.modalPresentationStyle = .overFullScreen
                self.VC?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    
    func updatePlansUI(){
        if self.planData[0].currency == "dollar"   {
            self.VC?.lblFreeTitle.text = self.planData[0].data?[0].title ?? ""
            self.VC?.lblFreeDays.text = "\(self.planData[0].data?[0].duration ?? 0)" + " Days "
            if self.planData[0].data?[1].duration ?? 0 == 1 {
                self.VC?.lblMonthTitle.text = self.planData[0].data?[1].title ?? ""
                self.VC?.lblMonthDays.text = "30" + " Days "
            }

            self.VC?.lblOneMonth.text = "$\(self.planData[0].data?[1].price ?? 0)"

            self.VC?.lbl3MonthTitle.text = self.planData[0].data?[2].title ?? ""
            self.VC?.lbl3MonthDays.text = "\(self.planData[0].data?[2].duration ??  0)" + " Months"
            self.VC?.lblThreeMonth.text = "$\(self.planData[0].data?[2].price ?? 0)"

            self.VC?.lbl6MonthTitle.text = self.planData[0].data?[3].title ?? ""
            self.VC?.lbl6MonthDays.text = "\(self.planData[0].data?[3].duration ?? 0)" + " Months"
            self.VC?.lblSixMonth.text = "$\(self.planData[0].data?[3].price ?? 0)"

            self.VC?.lbl12MonthTitle.text = self.planData[0].data?[4].title ?? ""
            self.VC?.lbl12MonthDays.text = "\(self.planData[0].data?[4].duration ?? 0)" + " Months"
            self.VC?.lbltwelveMonth.text = "$\(self.planData[0].data?[4].price ?? 0)"
        }else {
            self.VC?.lblFreeTitle.text = self.planData[0].data?[0].title ?? ""
            self.VC?.lblFreeDays.text = "\(self.planData[0].data?[0].duration ?? 0)" + " Days "
            if self.planData[0].data?[1].duration ?? 0 == 1 {
                self.VC?.lblMonthTitle.text = self.planData[0].data?[1].title ?? ""
                self.VC?.lblMonthDays.text = "30" + " Days "
            }

            self.VC?.lblOneMonth.text = "৳\(self.planData[0].data?[1].price ?? 0)"
            self.VC?.lbl3MonthTitle.text = self.planData[0].data?[2].title ?? ""
            self.VC?.lbl3MonthDays.text = "\(self.planData[0].data?[2].duration ??  0)" + " Months"
            self.VC?.lblThreeMonth.text = "৳\(self.planData[0].data?[2].price ?? 0)"

            self.VC?.lbl6MonthTitle.text = self.planData[0].data?[3].title ?? ""
            self.VC?.lbl6MonthDays.text = "\(self.planData[0].data?[3].duration ?? 0)" + " Months"
            self.VC?.lblSixMonth.text = "৳\(self.planData[0].data?[3].price ?? 0)"

            self.VC?.lbl12MonthTitle.text = self.planData[0].data?[4].title ?? ""
            self.VC?.lbl12MonthDays.text = "\(self.planData[0].data?[4].duration ?? 0)" + " Months"
            self.VC?.lbltwelveMonth.text = "৳\(self.planData[0].data?[4].price ?? 0)"
        }
        
    }
    
    
    func initialUIsetUp(){
       
        if paymentTitle == "FREE TRAIL" {
            if payment == true {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }
           
        }else if paymentTitle == "MONTHLY" {
            if payment == true {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }
        }else if paymentTitle == "QUARTERLY" {
            if payment == true {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }
        }
        else if paymentTitle == "HALF YEARLY" {
            if payment == true {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }
        }
        else if paymentTitle == "YEARLY" {
            if payment == true {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }
        }else {
            if payment == true {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }
        }
        
        
        
        VC?.Free_TrialView.tag = 0
        VC?.Monthly_View.tag = 1
        VC?.Quartly_View.tag = 2
        VC?.HalfYearly_View.tag = 3
        VC?.Yearly_View.tag = 4
        
        VC?.Free_TrialView.borderWidth = 2
        VC?.Free_TrialView.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
        VC?.img0.image = #imageLiteral(resourceName: "checked")
        
        VC?.Monthly_View.viewshadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 6.0, opacity: 0.50)
        
        VC?.HalfYearly_View.viewshadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 6.0, opacity: 0.50)
        
        VC?.Quartly_View.viewshadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 6.0, opacity: 0.50)
        
        VC?.Yearly_View.viewshadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 6.0, opacity: 0.50)
        VC?.Free_TrialView.viewshadow(offset: CGSize.init(width: 0, height: 2), color: UIColor.black, radius: 6.0, opacity: 0.50)
        
        VC?.Free_TrialView.layer.cornerRadius = 10

        VC?.self.btn_Freetrial.roundCorners([.layerMaxXMinYCorner, .layerMinXMinYCorner], radius: 30.0, borderColor: UIColor.clear, borderWidth: 0)
       
        VC?.lblOneMonth.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        VC?.lblThreeMonth.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        VC?.lblSixMonth.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        VC?.lbltwelveMonth.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        VC?.Free_TrialView.addGestureRecognizer(tap)
        tap.view?.tag = 0
        VC?.Free_TrialView.isUserInteractionEnabled = true
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap1.view?.tag = 1
        VC?.Monthly_View.addGestureRecognizer(tap1)
        VC?.Monthly_View.isUserInteractionEnabled = true
        
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap2.view?.tag = 2
        VC?.Quartly_View.addGestureRecognizer(tap2)
        VC?.Quartly_View.isUserInteractionEnabled = true
        
        let tap3 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap3.view?.tag = 3
        VC?.HalfYearly_View.addGestureRecognizer(tap3)
        VC?.HalfYearly_View.isUserInteractionEnabled = true
        
        let tap4 = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap4.view?.tag = 4
        VC?.Yearly_View.addGestureRecognizer(tap4)
        VC?.Yearly_View.isUserInteractionEnabled = true
    }
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if sender.view?.tag == 0 {
            if paymentTitle == "FREE TRAIL" {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }else {
                VC?.btnPlan.alpha = 1
                VC?.btnPlan.isUserInteractionEnabled = true
            }
            isTapOnFreeTrail = true
            self.freeTrailPlanId = self.planData[0].data?[0].id ?? 0
            VC?.subcriotionTitle = "freeTrail"
            VC?.selectTitle = "Your trail is activated."
            VC?.btnPlan.setTitle("START FREE TRAIL", for: .normal)
            VC?.img0.image = #imageLiteral(resourceName: "checked")
            VC?.img1.image = #imageLiteral(resourceName: "uncheck")
            VC?.img2.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
           
            VC?.Free_TrialView.borderWidth = 2
            VC?.Free_TrialView.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            VC?.Monthly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Monthly_View.borderWidth = 0
            VC?.Quartly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Quartly_View.borderWidth = 0
            VC?.HalfYearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.HalfYearly_View.borderWidth = 0
            VC?.Yearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Yearly_View.borderWidth = 0
            
            
        } else if sender.view?.tag == 1 {
            isTapOnFreeTrail = false
            palanID = self.planData[0].data?[1].id ?? 0
            if paymentTitle == "MONTHLY" {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }else {
                VC?.btnPlan.alpha = 1.0
                VC?.btnPlan.isUserInteractionEnabled = true
            }
            VC?.subcriotionTitle = "month"
            VC?.selectTitle = "Your monthly plan is activated."
            VC?.btnPlan.setTitle("BUY NOW", for: .normal)
            VC?.img1.image = #imageLiteral(resourceName: "checked")
            VC?.img0.image = #imageLiteral(resourceName: "uncheck")
            VC?.img2.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
            
            VC?.Monthly_View.borderWidth = 2
            VC?.Monthly_View.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            VC?.Free_TrialView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Free_TrialView.borderWidth = 0
            VC?.Quartly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Quartly_View.borderWidth = 0
            VC?.HalfYearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.HalfYearly_View.borderWidth = 0
            VC?.Yearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Yearly_View.borderWidth = 0
            
        } else if sender.view?.tag == 2 {
            isTapOnFreeTrail = false
            palanID = self.planData[0].data?[2].id ?? 0
            if paymentTitle == "QUARTERLY" {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }else {
                VC?.btnPlan.alpha = 1.0
                VC?.btnPlan.isUserInteractionEnabled = true
            }
            VC?.subcriotionTitle = "quarterly"
            VC?.selectTitle = "Your quartly plan is activated."
            VC?.btnPlan.setTitle("BUY NOW", for: .normal)
            VC?.img2.image = #imageLiteral(resourceName: "checked")
            VC?.img0.image = #imageLiteral(resourceName: "uncheck")
            VC?.img1.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
            
            VC?.Quartly_View.borderWidth = 2
            VC?.Quartly_View.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            VC?.Free_TrialView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Free_TrialView.borderWidth = 0
            VC?.Monthly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Monthly_View.borderWidth = 0
            VC?.HalfYearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.HalfYearly_View.borderWidth = 0
            VC?.Yearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Yearly_View.borderWidth = 0
            
        } else if sender.view?.tag == 3 {
            isTapOnFreeTrail = false
            palanID = self.planData[0].data?[3].id ?? 0
            if paymentTitle == "HALF YEARLY" {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }else {
                VC?.btnPlan.alpha = 1.0
                VC?.btnPlan.isUserInteractionEnabled = true
            }
            VC?.subcriotionTitle = "halfYearly"
            VC?.selectTitle = "Your half yearly plan is activated."
            VC?.btnPlan.setTitle("BUY NOW", for: .normal)
            VC?.img3.image = #imageLiteral(resourceName: "checked")
            VC?.img0.image = #imageLiteral(resourceName: "uncheck")
            VC?.img1.image = #imageLiteral(resourceName: "uncheck")
            VC?.img2.image = #imageLiteral(resourceName: "uncheck")
            VC?.img4.image = #imageLiteral(resourceName: "uncheck")
            
            VC?.HalfYearly_View.borderWidth = 2
            VC?.HalfYearly_View.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            VC?.Free_TrialView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Free_TrialView.borderWidth = 0
            VC?.Monthly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Monthly_View.borderWidth = 0
            VC?.Quartly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Quartly_View.borderWidth = 0
            VC?.Yearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Yearly_View.borderWidth = 0
            
        } else if sender.view?.tag == 4 {
            isTapOnFreeTrail = false
            if paymentTitle == "YEARLY" {
                VC?.btnPlan.alpha = 0.5
                VC?.btnPlan.isUserInteractionEnabled = false
            }else {
                VC?.btnPlan.alpha = 1.0
                VC?.btnPlan.isUserInteractionEnabled = true
            }
            
            palanID = self.planData[0].data?[4].id ?? 0
            VC?.subcriotionTitle = "YEARLY"
            VC?.selectTitle = "Your yearly plan is activated."
            VC?.btnPlan.setTitle("BUY NOW", for: .normal)
            VC?.img4.image = #imageLiteral(resourceName: "checked")
            VC?.img0.image = #imageLiteral(resourceName: "uncheck")
            VC?.img1.image = #imageLiteral(resourceName: "uncheck")
            VC?.img2.image = #imageLiteral(resourceName: "uncheck")
            VC?.img3.image = #imageLiteral(resourceName: "uncheck")
            
            
            VC?.Yearly_View.borderWidth = 2
            VC?.Yearly_View.borderColor = #colorLiteral(red: 0.04481492192, green: 0.284111917, blue: 0.5517202616, alpha: 1)
            VC?.Free_TrialView.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Free_TrialView.borderWidth = 0
            VC?.Monthly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Monthly_View.borderWidth = 0
            VC?.Quartly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.Quartly_View.borderWidth = 0
            VC?.HalfYearly_View.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            VC?.HalfYearly_View.borderWidth = 0
            
        }
    }
}
